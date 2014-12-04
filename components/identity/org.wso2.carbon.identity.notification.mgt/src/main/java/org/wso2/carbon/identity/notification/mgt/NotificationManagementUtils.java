/*
*
*   Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*   WSO2 Inc. licenses this file to you under the Apache License,
*   Version 2.0 (the "License"); you may not use this file except
*   in compliance with the License.
*   You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing,
*  software distributed under the License is distributed on an
*  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*  KIND, either express or implied.  See the License for the
*  specific language governing permissions and limitations
*  under the License.
*
*/

package org.wso2.carbon.identity.notification.mgt;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Properties;

/**
 * Util functionality for MessageSending Components
 */
@SuppressWarnings("unused")
public class NotificationManagementUtils {
    private static final Log log = LogFactory.getLog(NotificationMgtConfigBuilder.class);

    /**
     * Returns a set of properties which has keys starting with the given prefix
     *
     * @param prefix     prefix of the property key
     * @param properties Set of properties which needs be filtered for the given prefix
     * @return A set of properties which has keys starting with given prefix
     */
    public static Properties getPropertiesWithPrefix(String prefix, Properties properties) {

        if (prefix == null || properties == null) {
            throw new IllegalArgumentException("Prefix and properties should not be null to extract properties with " +
                    "certain prefix");
        }

        Properties subProperties = new Properties();
        Enumeration propertyNames = properties.propertyNames();

        while (propertyNames.hasMoreElements()) {
            String key = (String) propertyNames.nextElement();
            if (key.startsWith(prefix)) {
                subProperties.setProperty(key, (String) properties.remove(key));
            }
        }
        return subProperties;
    }

    /**
     * Returns a sub set of properties which has the given prefix key. ie properties which has numbers at the end
     *
     * @param prefix     Prefix of the key
     * @param properties Set of properties which needs be filtered for the given prefix
     * @return Set of sub properties which has keys starting with given prefix
     */
    public static Properties getSubProperties(String prefix, Properties properties) {

        // Stop proceeding if required arguments are not present
        if (prefix == null || properties == null) {
            throw new IllegalArgumentException("Prefix and Properties should not be null to get sub properties");
        }

        int i = 1;
        Properties subProperties = new Properties();
        while (properties.getProperty(prefix + "." + i) != null) {
            subProperties.put(prefix + "." + i, properties.remove(prefix + "." + i++));
        }
        return subProperties;
    }

    /**
     * @param prefix                 Prefix of the property key
     * @param propertiesWithFullKeys Set of properties which needs to be converted to single word key properties
     * @return Set of properties which has keys containing single word.
     */
    public static Properties buildSingleWordKeyProperties(String prefix,
                                                          Properties propertiesWithFullKeys) {

        // Stop proceeding if required arguments are not present
        if (prefix == null || propertiesWithFullKeys == null) {
            throw new IllegalArgumentException("Prefix and properties should not be null to get  properties with " +
                    "single word keys.");
        }

        propertiesWithFullKeys = NotificationManagementUtils.getPropertiesWithPrefix(prefix, propertiesWithFullKeys);
        Properties properties = new Properties();
        Enumeration propertyNames = propertiesWithFullKeys.propertyNames();

        while (propertyNames.hasMoreElements()) {
            String key = (String) propertyNames.nextElement();
            String newKey = key.substring(key.lastIndexOf(".") + 1, key.length());
            if (!newKey.trim().isEmpty()) {
                properties.put(newKey, propertiesWithFullKeys.remove(key));
            }
        }
        return properties;
    }

    /**
     * Replace place holders in the given string with properties
     *
     * @param content                Original content of the message which has place holders
     * @param replaceRegexStartsWith Placeholders starting regex
     * @param replaceRegexEndsWith   Placeholders ending regex
     * @param properties             Set of properties which are to be used for replacing
     * @return New content, place holders are replaced
     */
    public static String replacePlaceHolders(String content, String replaceRegexStartsWith,
                                             String replaceRegexEndsWith,
                                             Properties properties) {

        if (log.isDebugEnabled()) {
            log.debug("Replacing place holders of String " + content);
        }
        // Stop proceeding if required arguments are not present
        if (properties == null || content == null || replaceRegexEndsWith == null || replaceRegexStartsWith == null) {
            throw new IllegalArgumentException("Missing required arguments for replacing place holders");
        }

        if (content.contains(replaceRegexStartsWith)) {
            // For each property check whether there is a place holder and replace the place
            // holders exist.
            for (String key : properties.stringPropertyNames()) {
                content = content.replaceAll(replaceRegexStartsWith + key + replaceRegexEndsWith,
                        properties.getProperty(key));
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("No place holders are found to be replaced");
            }
        }
        return content;
    }

    /**
     * Read the file which is in given path and build the message template
     *
     * @param filePath Path of the message template file
     * @return String which contains message template
     */
    public static String readMessageTemplate(String filePath) {

        BufferedReader bufferedReader = null;
        String template = null;
        // Stop proceeding if required arguments are not present
        if (filePath == null || filePath.trim().isEmpty()) {
            throw new IllegalArgumentException("File path for message reading is not present");
        }

        // Reading the content of the file
        if (log.isDebugEnabled()) {
            log.debug("Reading template file in " + filePath);
        }
        try {
            String currentLine;
            bufferedReader = new BufferedReader(new FileReader(filePath));
            StringBuilder templateBuilder = new StringBuilder();

            while ((currentLine = bufferedReader.readLine()) != null) {
                templateBuilder.append(currentLine);
                templateBuilder.append(System.getProperty("line.separator"));
            }
            template = templateBuilder.toString();

        } catch (IOException e) {
            log.error("Error while reading email template", e);

        } finally {
            try {
                if (bufferedReader != null) {
                    bufferedReader.close();
                }
            } catch (IOException e) {
                log.error("Error while closing buffered reader", e);
            }
        }
        return template;
    }
}
