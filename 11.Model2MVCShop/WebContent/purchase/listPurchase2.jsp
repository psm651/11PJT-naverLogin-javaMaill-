<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
function fncGetPageList(currentPage) {
	$("#currentPage").val(currentPage)
	$("form").attr("method","POST").attr("action","/purchase/listPurchase2" ).submit();
}

$(function() {
	
	 $(".ct_list_pop td:nth-child(1) ").on("click" , function(){ 
		var tranNo = $(this).data("param");
			self.location = "/purchase/getPurchase?tranNo="+tranNo ;
		});
	 
	 $(".ct_list_pop td:nth-child(3) ").on("click" , function(){ 
			var tranNo = $(this).data("param1");
				self.location = "/user/getUser?userId=" ;
			});
	 $(".ct_list_pop:nth-child(2n+1)" ).css("background-color" , "whitesmoke");
	 
 });
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage} 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원ID</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">전화번호</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	<c:set var="i" value="0"/>
		<c:forEach var="purchase" items="${list}">
			<c:set var="i" value="${i+1 }"/>
	<tr class="ct_list_pop">
		<td align="center" data-param="${purchase.tranNo }">
			${i }
		</td>
		<td></td>
		<td align="left" data-param="${purchase.buyer.userId}">
			${purchase.buyer.userId}
		</td>
		<td></td>
		<td align="left">${purchase.receiverName }</td>
		<td></td>
		<td align="left">${purchase.receiverPhone }</td>
		<td></td>
		<td align="left">현재
					<c:choose>
				<c:when test = "${purchase.tranCode =='1  '}">구매완료</c:when>
				<c:when test = "${purchase.tranCode =='2  '}">배송중</c:when>
				<c:when test = "${purchase.tranCode =='3  '}">배송완료</c:when>
				<c:otherwise> 뾰로롱</c:otherwise>
			</c:choose>		
				상태 입니다.</td>
		<td></td>		
		<td align="left">

		<c:if test="${!empty user && user.role == 'admin' }">
		
			<c:choose>
				<c:when test = "${purchase.tranCode=='1  '}">구매완료<a href="/purchase/updateTranCodeActionByProd?prodNo=${purchase.purchaseProd.prodNo}&tranCode=2&currentPage=${resultPage.currentPage}&userId=${purchase.buyer.userId}">배송하기</a></c:when>
				<c:when test = "${purchase.tranCode=='2  '}">배송중</c:when>
				<c:when test = "${purchase.tranCode=='3  '}">배송완료</c:when>

			</c:choose>
		</c:if>
			
		<%-- <c:if test="${purchase.tranCode=='2  ' }">
		<a href="/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3&currentPage=${resultPage.currentPage}">물건도착</a>
			</c:if> --%>
		</td>
		
		<td align="left">
			
		</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	</c:forEach>
</table>

<!-- PageNavigation Start... -->
<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="currentPage" name="currentPage" value=""/>
			<%-- <% if( resultPage.getCurrentPage() <= resultPage.getPageUnit() ){ %>
					◀ 이전
			<% }else{ %>
					<a href="javascript:fncGetPurchaseList('<%=resultPage.getCurrentPage()-1%>')">◀ 이전</a>
			<% } %>

			<%	for(int i=resultPage.getBeginUnitPage();i<= resultPage.getEndUnitPage() ;i++){	%>
					<a href="javascript:fncGetPurchaseList('<%=i %>');"><%=i %></a>
			<% 	}  %>
	
			<% if( resultPage.getEndUnitPage() >= resultPage.getMaxPage() ){ %>
					이후 ▶
			<% }else{ %>
					<a href="javascript:fncGetPurchaseList('<%=resultPage.getEndUnitPage()+1%>')">이후 ▶</a>
			<% } %>
		<%System.out.println("resultPage.getCurrentPage()======="+resultPage.getCurrentPage()); %>
		<%System.out.println("resultPage.getEndUnitPage()======="+resultPage.getEndUnitPage()); %>
 --%>
 		 <jsp:include page="../common/pageNavigator.jsp"/>
     	</td>
	</tr>
</table>
<!-- PageNavigation End... -->
</form>

</div>

</body>
</html>