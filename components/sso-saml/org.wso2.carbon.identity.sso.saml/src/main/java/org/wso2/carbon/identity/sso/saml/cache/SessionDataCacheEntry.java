/*
 * Copyright (c) 2013, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.wso2.carbon.identity.sso.saml.cache;

import org.wso2.carbon.identity.sso.saml.dto.SAMLSSOSessionDTO;

public class SessionDataCacheEntry extends CacheEntry {

    private static final long serialVersionUID = -5753542359364950392L;

    private SAMLSSOSessionDTO sessionDTO;

    public SAMLSSOSessionDTO getSessionDTO() {
        return sessionDTO;
    }

    public void setSessionDTO(SAMLSSOSessionDTO sessionDTO) {
        this.sessionDTO = sessionDTO;
    }
}
