<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<!-- 참조 : http://getbootstrap.com/css/   참조 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
	<!-- Bootstrap Dropdown Hover CSS -->
   <link href="/css/animate.min.css" rel="stylesheet">
   <link href="/css/bootstrap-dropdownhover.min.css" rel="stylesheet">
   
    <!-- Bootstrap Dropdown Hover JS -->
   <script src="/javascript/bootstrap-dropdownhover.min.js"></script>
   
   
   <!--  ///////////////////////// CSS ////////////////////////// -->
	<style>
 		body {
            padding-top : 50px;
        }
        .left-box {
  float: left;
  width: 600px;
}
.right-box {
  float: right;
 width: 500px;
}
#banner { position: absolute; font-size: 8pt; top: 15px; left: 0; z-index: 10; background:#f1f1f1; padding:15px; border:1px solid #CCCCCC; text-align:center;}
	#banner > span {margin-bottom: 10px; display: block;}
	.banner_contents {min-height: 300px; background-color: #c0c0c0; width:100px; padding: 15px;}
     </style>
    
	<script type="text/javascript">
	$(function() {
		$("button:contains('확인')").on("click",function(){
	
			self.location="/product/listProduct?menu=manage"
		});
		$("button:contains('구매')").on("click",function(){
			
			self.location="/purchase/addPurchase?prodNo=${product.prodNo }"
		});
		$("button:contains('이전')").on("click",function(){
			
			history.go(-1)
		});
		
	});
	
	$(window).scroll(function() { 
		$('#banner').animate({top:$(window).scrollTop()+"px" },{queue: false, duration: 500});
	}); 
	
	</script>
<title>Insert title here</title>
</head>

<body>

<jsp:include page="/layout/toolbar.jsp" />

<div style="position:relative;float:right;width:210px;top:25px;right:55px;"> 
		<div id="banner">
			<span>최근에 본 상품</span>
			<div id="" class="banner_contents">
				<c:set var="i" value="0"/>
			<c:forEach var="product" items="${map}" end="5">
					<c:set var ="i" value="${i+1 }"/>
				<img src="/images/uploadFiles/${product.fileName}  " width="75" height="60"/>
				</c:forEach>
			</div>
		</div>
	</div>

<div class="container">
	<div class="page-header">
		<h3 class=" text-info">상품상세조회</h3>
	</div>	
	
	<div class="row">
		<div class='left-box'>
			<div class="col-xs-5 col-md-3 "><strong>상품이미지</strong></div>
			<div class="col-xs-6 col-md-3"><img src="/images/uploadFiles/${product.fileName}" width="450" height="420" align="absmiddle"/>
			</div>
		</div>
		
		<div class='right-box'>
		<div>
		</div>
			<div>
		  		<div class="col-xs-5 col-md-3"><strong>상품번호</strong></div>
				<div class="col-xs-8 col-md-4">${product.prodNo }</div>
			
				</br><hr/>
			
				<div class="col-xs-5 col-md-3"><strong>상품명</strong></div>
				<div class="col-xs-8 col-md-4">${product.prodName }</div>
			
				</br><hr/>
				<div class="col-xs-5 col-md-3"><strong>상품상세정보</strong></div>
				<div class="col-xs-8 col-md-4">${product.prodDetail}</div>
				</br><hr/>
				<div class="col-xs-5 col-md-3"><strong>제조일자</strong></div>
				<div class="col-xs-8 col-md-4">${product.manuDate}</div>
				</br><hr/>
				<div class="col-xs-5 col-md-3"><strong>가격</strong></div>
				<div class="col-xs-8 col-md-4">${product.price }</div>
				</br><hr/>
				<div class="col-xs-5 col-md-3"><strong>재고</strong></div>
				<div class="col-xs-8 col-md-4">${product.stock }</div>
				</br><hr/>
				<div class="col-xs-5 col-md-3 "><strong>등록일자</strong></div>
				<div class="col-xs-8 col-md-4">${product.regDate}</div>
				</br><hr/>
			</div>
		</div>
	</div>
	
	<div class="row">
	  		<div class="col-md-12 text-center ">
	  			<c:if test="${param.menu == 'manage' }">
	  				<button type="button" class="btn btn-primary">확인</button>
	  			</c:if>
	  			<c:if test="${param.menu != 'manage' }">
					<c:if test="${!empty sessionScope.user && product.stock != '0' }">
					<button type="button" class="btn btn-primary">구매</button>
					</c:if>
				</c:if>
					<button type="button" class="btn btn-primary">이전</button>
	  		</div>
		</div>
</div>
</body>
</html>