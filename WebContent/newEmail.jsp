<%--
 Copyright (C) 2009  HungryHobo@mail.i2p
 
 The GPG fingerprint for HungryHobo@mail.i2p is:
 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 
 This file is part of I2P-Bote.
 I2P-Bote is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 I2P-Bote is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ib" uri="I2pBoteTags" %>

<%--
    Valid actions:
        <default>           - show the "new email" form
        send                - send an email using the request data
        addToAddrBook       - add a recipient to the address book and return here
        lookup              - add one or more address book entries as recipients and return here
        addRecipientField   - add a recipient field
        removeRecipient<i>  - remove the recipient field with index i
        attach              - add the file given in the parameter "file" as an attachment
        removeAttachment<i> - remove the attachment with index i
        
    Other parameters:
        new    - true for new contact, false for existing contact
--%>

<c:choose>
    <c:when test="${param.action eq 'send'}">
        <jsp:forward page="sendEmail.jsp"/>
    </c:when>
    <c:when test="${param.action eq 'addToAddrBook'}">
        <c:set var="destparam" value="${param.destparamname}"/>
        <jsp:forward page="editContact.jsp">
            <jsp:param name="new" value="true"/>
            <jsp:param name="destination" value="${ib:escapeQuotes(param[destparam])}"/>
            <jsp:param name="forwardUrl" value="newEmail.jsp"/>
            <jsp:param name="backUrl" value="newEmail.jsp"/>
            <jsp:param name="paramsToCopy" value="sender,recipient*,to*,cc*,bcc*,replyto*,subject,message,attachmentNameOrig*,attachmentNameTemp*,forwardUrl,backUrl,paramsToCopy"/>
        </jsp:forward>
    </c:when>
    <c:when test="${param.action eq 'lookup'}">
        <jsp:forward page="addressBook.jsp">
            <jsp:param name="select" value="true"/>
            <jsp:param name="forwardUrl" value="newEmail.jsp"/>
            <jsp:param name="paramsToCopy" value="sender,recipient*,to*,cc*,bcc*,replyto*,subject,message,attachmentNameOrig*,attachmentNameTemp*,forwardUrl"/>
        </jsp:forward>
    </c:when>
</c:choose>

<ib:message key="New Email" var="title"scope="request"/>
<jsp:include page="header.jsp"/>

<ib:requirePassword forwardUrl="newEmail.jsp">
<div class="main">
    <form action="newEmail.jsp" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
        <table>
            <tr>
                <td>
                    <ib:message key="From:"/>
                </td>
                <td>
                    <select name="sender">
                        <option value="anonymous"><ib:message key="Anonymous"/></option>
                        <jsp:useBean id="jspHelperBean" class="i2p.bote.web.JSPHelper"/>
                        <c:forEach items="${jspHelperBean.identities.all}" var="identity">
                            <c:set var="selected" value=""/>
                            <c:if test="${fn:contains(param.sender, identity.key)}">
                                <c:set var="selected" value=" selected"/>
                            </c:if>
                            <c:if test="${empty param.sender && identity.default}">
                                <c:set var="selected" value=" selected"/>
                            </c:if>
                            <option value="${identity.publicName} &lt;${identity.key}&gt;"${selected}>
                                ${identity.publicName}
                                <c:if test="${!empty identity.description}"> - ${identity.description}</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            
            <%-- Add an address line for each recipient --%>
            <c:set var="recipients" value="${ib:mergeRecipientFields(pageContext.request)}"/>
            <c:forEach var="recipient" items="${recipients}" varStatus="status">
                <c:set var="recipientField" value="recipient${status.index}"/>
                <tr><td>
                    <c:set var="recipientTypeField" value="recipientType${status.index}"/>
                    <c:set var="recipientType" value="${param[recipientTypeField]}"/>
                    <select name="recipientType${status.index}">
                        <c:set var="toSelected" value="${recipientType eq 'to' ? ' selected' : ''}"/>
                        <c:set var="ccSelected" value="${recipientType eq 'cc' ? ' selected' : ''}"/>
                        <c:set var="bccSelected" value="${recipientType eq 'bcc' ? ' selected' : ''}"/>
                        <c:set var="replytoSelected" value="${recipientType eq 'replyto' ? ' selected' : ''}"/>
                        <option value="to"${toSelected}><ib:message key="To:"/></option>
                        <option value="cc"${ccSelected}><ib:message key="CC:"/></option>
                        <option value="bcc"${bccSelected}><ib:message key="BCC:"/></option>
                        <option value="replyto"${replytoSelected}><ib:message key="Reply To:"/></option>
                    </select>
                </td><td>
                    <input type="text" size="70" name="${recipientField}" value="${ib:escapeQuotes(recipient.address)}"/>
                    <c:choose>
                        <c:when test="${status.last}">
                            <input type="hidden" name="destparamname" value="${recipientField}"/>
                            <button type="submit" name="action" value="addToAddrBook">&#x2794;<img src="images/addressbook.gif"/></button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" name="action" value="removeRecipient${status.index}">-</button>
                        </c:otherwise>
                    </c:choose>
                </td></tr>
            </c:forEach>

            <tr>
                <td/>
                <td style="text-align: right;">
                    <button type="submit" name="action" value="addRecipientField">+</button>
                    <button type="submit" name="action" value="lookup"><ib:message key="Addr. Book..."/></button>
                </td>
            </tr>
            <tr>
                <td valign="top"><br/><ib:message key="Subject:"/></td>
                <td><input class="widetextfield" type="text" size="70" name="subject" value="${ib:escapeQuotes(param.subject)}"/></td>
            </tr>
            
            <%-- Attachments --%>
            <tr>
                <td valign="top"><ib:message key="Attachments:"/></td>
                <td><table>
                    <c:set var="maxAttachmentIndex" value="-1"/>
                    <c:forEach items="${param}" var="parameter">
                        <c:if test="${fn:startsWith(parameter.key, 'attachmentNameOrig')}">
                            <c:set var="attachmentIndex" value="${fn:substringAfter(parameter.key, 'attachmentNameOrig')}"/>
                            <c:set var="removeAction" value="removeAttachment${attachmentIndex}"/>
                            <c:set var="removed" value="${param.action eq removeAction}"/>
                            <c:if test="${!removed}">
	                            <c:if test="${attachmentIndex gt maxAttachmentIndex}">
	                                <c:set var="maxAttachmentIndex" value="${attachmentIndex}"/>
	                            </c:if>
	                            <tr>
	                                <td>
	                                    ${parameter.value}
	                                    <input type="hidden" name="attachmentNameOrig${attachmentIndex}" value="${parameter.value}"/>
	                                    <c:set var="tempFileParamName" value="attachmentNameTemp${attachmentIndex}"/>
	                                    <input type="hidden" name="attachmentNameTemp${attachmentIndex}" value="${param[tempFileParamName]}"/>
	                                </td>
	                                <ib:message key="Remove this attachment" var="linkTitle"/>
	                                <td><button type="submit" name="action" value="removeAttachment${attachmentIndex}" title="${linkTitle}">-</button></td>
	                            </tr>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${param.action eq 'attach'}">
                        <tr><td>
                            <%-- the newAttachment request attribute contains a UploadedFile object, see MultipartFilter.java --%>
                            ${requestScope['newAttachment'].originalFilename}
                            <c:set var="maxAttachmentIndex" value="${maxAttachmentIndex + 1}"/>
                            <input type="hidden" name="attachmentNameOrig${maxAttachmentIndex}" value="${requestScope['newAttachment'].originalFilename}"/>
                            <input type="hidden" name="attachmentNameTemp${maxAttachmentIndex}" value="${requestScope['newAttachment'].tempFilename}"/>
                            <c:remove var="newAttachment" scope="request"/>
                        </td><td>
                            <button type="submit" name="action" value="removeAttachment${maxAttachmentIndex}">-</button>
                        </td></tr>
                    </c:if>
                    
                    <tr>
                        <td><input type="file" name="newAttachment"/></td>
                        <ib:message key="Add another attachment" var="linkTitle"/>
                        <td><button type="submit" name="action" value="attach" title="${linkTitle}"><ib:message key="Attach"/></button></td>
                    </tr>
                    <tr>
                        <td colspan="2"><div style="font-size: 0.8em;"><ib:message key="It is recommended to keep attachments below 500 kBytes."/></div></td>
                    </tr>
                </table></td>
            </tr>
            
            <%-- The message field --%>
            <tr>
                <td valign="top"><br/><ib:message key="Message:"/></td>
                <td>
                    <textarea rows="30" cols="70" name="message"><c:if test="${!empty param.quoteMsgId}">
<%-- The following lines are not indented because the indentation would show up as blank chars on the textarea --%>
<c:set var="origEmail" value="${ib:getEmail(param.quoteMsgFolder, param.quoteMsgId)}"/>
<ib:message key="{0} wrote:" hide="true">
    <ib:param value="${ib:getShortSenderName(origEmail.sender, 50)}"></ib:param>
</ib:message><ib:quote text="${fn:escapeXml(origEmail.text)}"/></c:if><c:if test="${empty param.quoteMsgId}">${fn:escapeXml(param.message)}</c:if></textarea>
                </td>
            </tr>
            <tr>
                <td colspan=3 align="center">
                    <button type="submit" name="action" value="send"><ib:message key="Send"/></button>
                    <button type="submit" name="action" disabled="disabled"><ib:message key="Save"/></button>
                </td>
            </tr>
        </table>
    </form>
</div>
</ib:requirePassword>

<jsp:include page="footer.jsp"/>
