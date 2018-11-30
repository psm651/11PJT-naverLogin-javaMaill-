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
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
   <script src="/javascript/bootstrap-dropdownhover.min.js"></script>
   
   <!--  ///////////////////////// CSS ////////////////////////// -->
	<style>
	  body {
            padding-top : 50px;
        }
  .thumbnail-wrappper {
   width: 35%; 
   }
   .thumbnail { 
   position: relative; padding-top: 100%; /* 1:1 ratio */ overflow: hidden; 
   }
    .thumbnail .centered { 
    position: absolute; top: 0; left: 0; right: 0; bottom: 0; -webkit-transform: translate(50%,50%);
     -ms-transform: translate(50%,50%); transform: translate(50%,50%); 
     }
     .thumbnail .centered img {
      position: absolute; top: 0; left: 0; max-width: 100%; height: auto; -webkit-transform: translate(-50%,-50%); 
      -ms-transform: translate(-50%,-50%); transform: translate(-50%,-50%); 
      }
#banner { position: absolute; font-size: 8pt; top: 15px; left: 0; z-index: 10; background:#f1f1f1; padding:15px; border:1px solid #CCCCCC; text-align:center;}
	#banner > span {margin-bottom: 10px; display: block;}
	.banner_contents {min-height: 300px; background-color: #c0c0c0; width:100px; padding: 15px;}



    
    </style>
<!--     
   jQuery UI toolTip 사용 CSS
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  jQuery UI toolTip 사용 JS
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> -->
  
<c:if test="${param.menu=='manage' }">
<title>상품 목록조회</title>
 </c:if>
 <c:if test="${param.menu=='search' }">
 <title>상품 관리</title>
 </c:if>	

<link rel="stylesheet" href="/css/admin.css" type="text/css"><!-- 
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script> -->
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

  $(function() {
	
			$("img").on("click" , function(){
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
//
$( function() {
	$( "#searchKeyword" ).autocomplete({
	      source: function( request, response ) {
	        $.ajax( {
	          url: "/product/json/autocomplete",
	          dataType: "json",
	          method : "POST",
	          data: JSON.stringify({
	       		searchKeyword:$( "#searchKeyword").val()
	          }),
	          headers : {
	  			"Accept" : "application/json",
	  			"Content-Type" : "application/json"
	  		},
	  		  success: function( data ) {
      	  console.log(data);
          response( data );
        } 
	        } );
	      },
	      minLength:1,
	     
	    } );
});
// 

var currentPage = ${resultPage.currentPage};

$(window).scroll(function() {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	 
     
      $.ajax({
			url : "/product/json/listProduct",
			method : "POST",
			data : JSON.stringify({
						currentPage:++currentPage,
						searchKeyword:$( "#searchKeyword" ).val(),
						searchCondition:$( "#searchCondition" ).val()
						
					}),
			dataType: "json",
			headers : {
				"Accept" : "application/json",
				"Content-Type" : "application/json"
			},
			success : function(JSONData, status) {
				 
		
				var list = JSONData["list"];
	
				list.forEach(function(item,index,array) {

				       $("#enters").append("<div><div class='col-sm-6 col-md-3'> <div class='thumbnail-wrapper'> <div class='thumbnail'><div class='centered'>"
				    		   +" <img src='/images/uploadFiles/"+item['fileName']+"' data-param1='"+item['prodNo']+"'/>"
				    		   + "</div></div> <div class='caption'> <h4>"+item['prodName']+" </h4><p>"+item['prodDetail']+" </p>"
						         +"</div></div></div></div>"
					   ); 
				});
				$(function() {
					console.log("${param.menu}");
					console.log()
					$("img").on("click" , function(){
					var prodNo = $(this).data("param1");
					if ( ${param.menu=="search"}) {
						self.location = "/product/getProduct?prodNo="+prodNo+"&menu=search";
					};

					if ( ${param.menu=="manage"}) {
						self.location = "/product/updateProduct?prodNo="+prodNo+"&menu=manage";
					};
					});
				}); 
   			 }      
   		 }); 
		}
	});
$(window).scroll(function() { 
	$('#banner').animate({top:$(window).scrollTop()+"px" },{queue: false, duration: 500});
}); 

	</script>
	</head>

	<body>

	<jsp:include page="/layout/toolbar.jsp" />
	
	<div style="position:relative;float:right;width:210px;top:25px;right:55px;"> 
		<div id="banner">
			<span>최근에 본 상품</span>
			<div id="" class="banner_contents">
				<c:set var="i" value="0"/>
			<c:forEach var="product" items="${cookieList}" end="5">
					<c:set var ="i" value="${i+1 }"/>
				<img src="/images/uploadFiles/${product.fileName}  " width="75" height="60"/>
				</c:forEach>
			</div>
		</div>
	</div>
	
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
						    <select class="form-control" id="searchCondition"name="searchCondition" >
							<c:if test="${!empty user && user.role == 'admin' }">
						<option value="0" ${! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
							</c:if>
						<option value="1" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
						<option value="2" ${! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
							</select>
					  </div>
					  
					  <div class="form-group">
						    <label class="sr-only" for="searchKeyword">검색어</label>
						    <input type="text" class="form-control" id="searchKeyword" name="searchKeyword"  placeholder="검색어" value="${! empty search.searchKeyword ? search.searchKeyword : '' }"  >
					  </div>
					  
					  <button type="button" class="btn btn-default">검색</button>
					  
					  <!-- PageNavigation 선택 페이지 값을 보내는 부분 -->
					  <input type="hidden" id="currentPage" name="currentPage" value=""/>
					  
					</form>
		    	</div>
		    	
			</div>
			</br></br></br></br>
	
	<table class="table table-hover table-striped" >
		<tbody>
			<c:set var="i" value="0"/>
			<div class="row" id="enters">
				<c:forEach var="product" items="${list}">
					<c:set var ="i" value="${i+1 }"/>
		
	  				<div class="col-sm-6 col-md-3">
						    <div class="thumbnail-wrapper"> 
							    <div class="thumbnail">
								     <div class="centered">
									      <img src="/images/uploadFiles/${product.fileName}  " data-param1="${product.prodNo}"/>
	
	      						</div>
	      					</div>
	            			<div class="caption">
								        <h4>${product.prodName }</h4>
									        <p>${product.prodDetail }</p>
									        <p></p>
							     </div>
	    				</div>
	  				</div>
	  			</c:forEach>
			</div>
		</tbody>
	</table>	  
	</div>
	 
	 	
	 	
	
	<%-- 	<jsp:include page="../common/pageNavigator_new.jsp"/> --%>
		
	
	
	
	</body>
</html>
