<!--
 ~ Copyright (c) WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 ~
 ~ WSO2 Inc. licenses this file to you under the Apache License,
 ~ Version 2.0 (the "License"); you may not use this file except
 ~ in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~    http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing,
 ~ software distributed under the License is distributed on an
 ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 ~ KIND, either express or implied.  See the License for the
 ~ specific language governing permissions and limitations
 ~ under the License.
 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar"
	prefix="carbon"%>
<%@ page
        import="org.wso2.carbon.identity.entitlement.ui.client.EntitlementPolicyAdminServiceClient" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.identity.entitlement.stub.dto.StatusHolder" %>
<%@ page import="org.wso2.carbon.identity.entitlement.stub.dto.PaginatedStatusHolder" %>
<%@ page import="org.wso2.carbon.identity.entitlement.common.EntitlementConstants" %>
<%@ page import="java.util.Date" %>


<%

    int numberOfPages = 0;
    String pageNumber = request.getParameter("pageNumber");
    if (pageNumber == null) {
        pageNumber = "0";
    }
    int pageNumberInt = 0;
    try {
        pageNumberInt = Integer.parseInt(pageNumber);
    } catch (NumberFormatException ignored) {
    }

    String statusSearchString = request.getParameter("statusSearchString");
    if (statusSearchString == null) {
        statusSearchString = "*";
    } else {
        statusSearchString = statusSearchString.trim();
    }

    String typeFilter = request.getParameter("typeFilter");
    if (typeFilter == null || "".equals(typeFilter)) {
        typeFilter = "ALL";
    }

    String subscriberId = request.getParameter("subscriberId");
    String paginationValue = "subscriberId=" + subscriberId +"&typeFilter=" + typeFilter +
            "&statusSearchString=" + statusSearchString;
    StatusHolder[] statusHolders = new StatusHolder[0];

    try {
        String serverURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
        ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.                                                                           CONFIGURATION_CONTEXT);
        String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);
        EntitlementPolicyAdminServiceClient client = new EntitlementPolicyAdminServiceClient(cookie,
                serverURL, configContext);
        String type = typeFilter;
        if("ALL".equals(type)){
            type = null;
        }
        PaginatedStatusHolder holder = client.getStatusData(EntitlementConstants.Status.ABOUT_SUBSCRIBER,
                subscriberId,  type, statusSearchString, pageNumberInt);
        statusHolders = holder.getStatusHolders();
        numberOfPages = holder.getNumberOfPages();
    } catch (Exception e) {
%>
<script type="text/javascript">
    CARBON.showErrorDialog('<%=e.getMessage()%>', function () {
        location.href = "index.jsp";
    });
</script>
<%
    }
%>

<script type="text/javascript">
    function searchService() {
        document.searchForm.submit();
    }

    function doCancel(){
        location.href = 'policy-publish.jsp';
    }

    function getSelectedType() {
        var comboBox = document.getElementById("typeFilter");
        var typeFilter = comboBox[comboBox.selectedIndex].value;
        location.href = 'show-subscriber-status.jsp?typeFilter=' + typeFilter + "&policyid=" +  "<%=subscriberId%>";
    }
</script>

<fmt:bundle basename="org.wso2.carbon.identity.entitlement.ui.i18n.Resources">
    <carbon:breadcrumb
            label="subscriber.status"
            resourceBundle="org.wso2.carbon.identity.entitlement.ui.i18n.Resources"
            topPage="true"
            request="<%=request%>"/>
<div id="middle">
    <h2><fmt:message key="subscriber.status"/></h2>
<div id="workArea">
    <form action="show-subscriber-status.jsp" name="searchForm" method="post">
        <table style="border:0;
                                                !important margin-top:10px;margin-bottom:10px;">
            <tr>
                <td>
                    <table style="border:0; !important">
                        <tbody>
                        <tr style="border:0; !important">
                            <td style="border:0; !important">
                                <nobr>
                                    <%--<fmt:message key="policy.status.type"/>--%>
                                    <%--<select name= "typeFilter" id="typeFilter"  onchange="getSelectedType();">--%>
                                        <%--<%--%>
                                            <%--if (typeFilter.equals("ALL")) {--%>
                                        <%--%>--%>
                                        <%--<option value="ALL" selected="selected"><fmt:message key="all"/></option>--%>
                                        <%--<%--%>
                                        <%--} else {--%>
                                        <%--%>--%>
                                        <%--<option value="ALL"><fmt:message key="all"/></option>--%>
                                        <%--<%--%>
                                            <%--}--%>
                                            <%--for (String type : EntitlementConstants.StatusTypes.ALL_TYPES) {--%>
                                                <%--if (typeFilter.equals(type)) {--%>
                                        <%--%>--%>
                                        <%--<option value="<%= type%>" selected="selected"><%= type%>--%>
                                        <%--</option>--%>
                                        <%--<%--%>
                                        <%--} else {--%>
                                        <%--%>--%>
                                        <%--<option value="<%= type%>"><%= type%>--%>
                                        <%--</option>--%>
                                        <%--<%--%>
                                                <%--}--%>
                                            <%--}--%>
                                        <%--%>--%>
                                    <%--</select>--%>
                                    <%--&nbsp;&nbsp;&nbsp;--%>
                                <fmt:message key="search.status.by.policy"/>
                                <input type="text" name="statusSearchString"
                                       value="<%= statusSearchString != null? statusSearchString :""%>"/>&nbsp;
                                </nobr>
                                <input type="hidden" name="subscriberId"   id="subscriberId"
                                       value="<%=subscriberId%>"/>
                            </td>
                            <td style="border:0; !important">
                                <a class="icon-link" href="#" style="background-image: url(images/search.gif);"
                                   onclick="searchService(); return false;"
                                   alt="<fmt:message key="search"/>"></a>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    <table  class="styledLeft"  style="width: 100%;margin-top:10px;">
        <thead>
        <tr>
            <th><fmt:message key="time.stamp"/></th>
            <th><fmt:message key="action"/></th>
            <th><fmt:message key="policy.user"/></th>
            <th><fmt:message key="target"/></th>
            <th><fmt:message key="target.action"/></th>
            <th><fmt:message key="status"/></th>
            <th><fmt:message key="details"/></th>
        </tr>
        </thead>
        <%
            if(statusHolders != null){
            for(StatusHolder dto : statusHolders){
                if(dto != null && dto.getTimeInstance() != null){
        %>
        <tr>
            <td><%=(new Date(Long.parseLong(dto.getTimeInstance()))).toString()%></td>
            <td><% if(dto.getType() != null){%> <%=dto.getType()%><%}%></td>
            <td><% if(dto.getUser() != null){%> <%=dto.getUser()%><%}%></td>
            <td><% if(dto.getTarget() != null){%> <%=dto.getTarget()%><%}%></td>
            <td><% if(dto.getTargetAction() != null){%> <%=dto.getTargetAction()%><%}%></td>
            <td><% if(dto.getSuccess()){%> <fmt:message key="status.success"/> <%}
                                            else {%> <fmt:message key="status.fail"/> <%} %></td>
            <td><% if(dto.getMessage() != null){%> <%=dto.getMessage()%><%}%></td>
        </tr>
        <%
                }
            }
        } else {
        %>
        <tr class="noRuleBox">
            <td colspan="7"><fmt:message key="no.status.defined"/><br/></td>
        </tr>
        <%
            }
        %>
    </table>
    <carbon:paginator pageNumber="<%=pageNumberInt%>"
                      numberOfPages="<%=numberOfPages%>"
                      page="show-subscriber-status.jsp"
                      pageNumberParameterName="pageNumber"
                      parameters="<%=paginationValue%>"
                      resourceBundle="org.wso2.carbon.identity.entitlement.ui.i18n.Resources"
                      prevKey="prev" nextKey="next"/>
</div>
    <div class="buttonRow">
        <a onclick="doCancel()" class="icon-link" style="background-image:none;">
            <fmt:message key="back.to.subscribersList"/></a><div style="clear:both"></div>
    </div>
</div>
</fmt:bundle>