<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">

<meta name="viewport" content="width=device-width, initial-scale=1.0" />


<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
	
	<!-- Bootstrap Dropdown Hover CSS -->
	 <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
   <link href="/css/animate.min.css" rel="stylesheet">
   <link href="/css/bootstrap-dropdownhover.min.css" rel="stylesheet">
    <!-- Bootstrap Dropdown Hover JS -->
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
   <script src="/javascript/bootstrap-dropdownhover.min.js"></script>
   
   <!--  ///////////////////////// CSS ////////////////////////// -->
	<style>
	  body {
            padding-top : 50px;
        }
    </style>
    
   <!-- jQuery UI toolTip 사용 CSS-->
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <!-- jQuery UI toolTip 사용 JS-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
<c:if test="${param.menu=='manage' }">
<title>상품 목록조회</title>
 </c:if>
 <c:if test="${param.menu=='search' }">
 <title>상품 관리</title>
 </c:if>	

<link rel="stylesheet" href="/css/admin.css" type="text/css">
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

function fncGetPageList(currentPage) {
	$("#currentPage").val(currentPage)
	$("form").attr("method","POST").attr("action", "/product/listProduct?menu=${param.menu }" ).submit();
}

$(function() {
	
	 $( "button.btn.btn-default" ).on("click" , function() {
			fncGetPageList(1);
		});
	 $("#searchKeyword").keypress(function(event){
			if (event.which==13) {
				fncGetPageList(1);
			}
			return; 
		})

		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	
});

/* $( function() {
    $( "#prodFile" ).tooltip({
      content: function() {
     
          return "<h3>"
			+"상품이미지 : "+"<img src='/images/uploadFiles/ "+JSONData.fileName+"' width='300' height='280' align='absmiddle'/>"+"<td><br/>"
			+"상품명 : "+JSONData.prodName+"<br/>"
			+"가격 : "+JSONData.price+"<br/>"
			+"상품 상세정보 : "+JSONData.prodDetail+"<br/>"
			+"잔여 : "+JSONData.stock+"<br/>"
			+"</h3>";
        }
    });
  } );
   */
 /*  
$(function() {
	
	$("#prodNAME ").on("click" , function(){
	var prodNo = $(this).data("param");
	if ( ${param.menu=="search"}) {
		self.location = "/product/getProduct?prodNo="+prodNo+"&menu=search";
	};

	if ( ${param.menu=="manage"}) {
		self.location = "/product/updateProduct?prodNo="+prodNo+"&menu=manage";
	};
	});
});
  */
  $(function() {
	
			$("#prodFile ").on("click" , function(){
			var prodNo = $(this).data("param1");
			if ( ${param.menu=="search"}) {
				self.location = "/product/getProduct?prodNo="+prodNo+"&menu=search";
			};

			if ( ${param.menu=="manage"}) {
				self.location = "/product/updateProduct?prodNo="+prodNo+"&menu=manage";
			};
			});
		});
	 

$(function() {
	$( "input[name='order']" ).on("click" , function() {
		
						fncGetPageList(1);
});
	

	$("#prodNAME ").on("click" , function(){
	var prodNo = $(this).data("param");
	var prodName = $(this).text().trim();
	$.ajax(
			{
				url : "/product/json/getProduct/"+prodNo,
				method : "GET",
				dataType : "json",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {
					var displayValue = "<h3><tr><td>"
						+"상품이미지 : "+"<img src='/images/uploadFiles/ "+JSONData.fileName+"' width='300' height='280' align='absmiddle'/>"+"<td><br/>"
						+"<td>상품명 : "+JSONData.prodName+"<br/>"
						+"가격 : "+JSONData.price+"<br/>"
						+"상품 상세정보 : "+JSONData.prodDetail+"<br/>"
						+"잔여 : "+JSONData.stock+"<br/>"
						+"</td></h3></tr>";
					$("h3").remove();
					$( "#"+prodName+"" ).html(displayValue);
					
				}
			});
	}); 
});


</script>
</head>

<body>

<jsp:include page="/layout/toolbar.jsp" />
<div class="container">
	<div class="page-header text-info">
	       <h3>
	       	<c:if test="${param.menu== 'search'}">
						상품 목록조회
			</c:if>
			<c:if test="${param.menu=='manage' }">
						 상품 관리
			</c:if>
	</h3>
	    </div>

	    <div class="row">
	    
		    <div class="col-md-6 text-left">
		    	<p class="text-primary">
		    		전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
		    	</p>
		    </div>
		    
		    <div class="col-md-6 text-right">
			    <form class="form-inline" name="detailForm">
			    
				  <div class="form-group">
				    <select class="form-control" name="searchCondition" >
						<c:if test="${!empty user && user.role == 'admin' }">
				<option value="0" ${! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				</c:if>
				<option value="1" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2" ${! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
					</select>
				  </div>
				  
				  <div class="form-group">
				    <label class="sr-only" for="searchKeyword">검색어</label>
				    <input type="text" class="form-control" id="searchKeyword" name="searchKeyword"  placeholder="검색어"
				    			 value="${! empty search.searchKeyword ? search.searchKeyword : '' }"  >
				  </div>
				  
				  <button type="button" class="btn btn-default">검색</button>
				  
				  <!-- PageNavigation 선택 페이지 값을 보내는 부분 -->
				  <input type="hidden" id="currentPage" name="currentPage" value=""/>
				  
				</form>
	    	</div>
	    	
		</div>

<table class="table table-hover table-striped" >
        <thead>
	<tr>
		            <th align="center">No</th>
		<c:if test="${!empty user && user.role == 'admin' }">
		            <th align="center">상품번호</th>
		</c:if>
		            <th align="center">상품이미지</th>
		                        <th align="center">상품명</th>
		                                    <th align="center">상품상세설명</th>
		                                                <th align="center">가격</th>
		                                                            <th align="center">등록일</th>
		                                                                        <th align="center">현재상태</th>
	</tr>
</thead>
<tbody>

	<c:set var="i" value="0"/>
		<c:forEach var="product" items="${list}">
			<c:set var ="i" value="${i+1 }"/>
		

		<td align="center">${i }</td>
		<c:if test="${!empty user && user.role == 'admin' }">
		<td align="left">${product.prodNo}</td>
		</c:if>
		<td id="prodFile" data-param1="${product.prodNo}">
			<img src="/images/uploadFiles/${product.fileName}" width="100" height="80" align="absmiddle"/>
		</td>
		<td align="left"  id="prodNAME" data-param="${product.prodNo }       ">
			${product.prodName }
		<td align="left">${product.prodDetail }</td>
		<td align="left">${product.price }</td>
		<td align="left">${product.manuDate }</td>
		<td align="left">
		<c:if test = "${product.stock =='0'}">재고없음</c:if>
		<c:if test = "${product.stock !='0'}">판매가능</c:if>
		</td>

	<tr>

			<td colspan="8">
				<div class="col-md-9">
				<i id="${product.prodName}"></i>
				<input type = "hidden" value="${product.prodName}">
				</div>
			</td>
			
		</tr>
	
	</c:forEach>
	</tbody>
</table>

  <!--  table End /////////////////////////////////////-->
	  
 	</div>
 	<!--  화면구성 div End /////////////////////////////////////-->
 	
 	
 	<!-- PageNavigation Start... -->
	<jsp:include page="../common/pageNavigator_new.jsp"/>
	<!-- PageNavigation End... -->
	
<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="currentPage" name="currentPage" value=""/>
			
		 <jsp:include page="../common/pageNavigator.jsp"/>
    	</td>
	</tr>
	
</table> --%>



</body>
</html>
