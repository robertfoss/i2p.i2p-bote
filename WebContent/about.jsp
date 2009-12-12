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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="ib" uri="I2pBoteTags" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="About I2P-Bote"/>
</jsp:include>

<div class="main">
    <h2>
        I2P-Bote Version <ib:printVersion/>
    </h2>
    <br/>
    
    <table><tr>
        <td><strong>Author:</strong></td>
    </tr><tr>
        <td></td><td>HungryHobo@mail.i2p</td>
    </tr><tr>
        <td><strong>Contributors:</strong></td>
    </tr><tr>
        <td></td><td>Mixxy</td>
    </tr></table>
</div>

<jsp:include page="footer.jsp"/>