package com.model2.mvc.web.product;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;


//==> 회원관리 Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method 구현 않음
		
	public ProductController(){
		System.out.println(this.getClass());
	}
	
	//==> classpath:config/common.properties  ,  classpath:config/commonservice.xml 참조 할것
	//==> 아래의 두개를 주석을 풀어 의미를 확인 할것
	@Value("#{commonProperties['pageUnit']}")
	//@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	//@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	
	@RequestMapping(value="addProduct", method = RequestMethod.GET)
	public String addProduct() throws Exception {

		System.out.println("/product/addProduct : GET");
	
		
		return "redirect:/product/addProductView.jsp";
	}
	
	@RequestMapping(value="addProduct", method = RequestMethod.POST)
	public String addProduct( @ModelAttribute("product") Product product, @RequestParam("fileNa") MultipartFile file ) throws Exception {

		
		System.out.println("/product/addProduct : POST");
		//Business Logic
		File file1=new File("C:\\workspace\\11.Model2MVCShop\\WebContent\\images\\uploadFiles\\",file.getOriginalFilename());
		
		file.transferTo(file1);
		product.setFileName(file.getOriginalFilename());
		productService.addProduct(product);
		
		return "forward:/product/addProductConform.jsp";
	}
	
	@RequestMapping(value="getProduct", method = RequestMethod.GET)
	public String getProduct( @RequestParam("prodNo") int prodNo ,@CookieValue(value="history", required=false) String history, HttpServletResponse response, Model model ) throws Exception {
		
		System.out.println("/product/getProduct : GET");
		//Business Logic
		Product product = productService.getProduct(prodNo);
		List<Product> map=new ArrayList<Product>();
		if (history==null || history.length()==0) {
			history = prodNo+"";
		}else {
			if (history.indexOf(prodNo+"")==-1) {
				history = prodNo+","+history;
			}			
			
		}
		
		Cookie cookie= new Cookie("history", history);
		cookie.setPath("/");
		response.addCookie(cookie);
		
		
		String[] h =history.split(",");
		
		for (int i = 0; i < h.length; i++) {
			
				
				/*Product cookieProduct=productService.getProduct(Integer.parseInt(h[i]));*/
			
				map.add(productService.getProduct(Integer.parseInt(h[i])));
			
		}
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@이게맵이다"+map);
		
		
		// Model 과 View 연결
		model.addAttribute("product", product);
		model.addAttribute("map", map);
		
		return "forward:/product/getProduct.jsp";
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.GET)
	public String updateProduct( @RequestParam("prodNo") int prodNo , Model model ) throws Exception{

		System.out.println("/product/updateProduct : GET");
		//Business Logic
		Product product = productService.getProduct(prodNo);
		// Model 과 View 연결
		model.addAttribute("product", product);
		
		return "forward:/product/updateProductView.jsp";
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.POST)
	public String updateProduct( @ModelAttribute("product") Product product , Model model) throws Exception{

		System.out.println("/product/updateProduct : GET");
		//Business Logic
		
		productService.updateProduct(product);
		
	
		return "redirect:/product/getProduct?prodNo="+product.getProdNo()+"&menu=manage";
	}
	
	@RequestMapping(value="listProduct")
	public String listProduct( @ModelAttribute("search") Search search ,@CookieValue(value="history", required=false) String history, Model model , HttpServletResponse response, HttpServletRequest request) throws Exception{
		
		System.out.println("/product/listProduct : GET / POST");
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
	
		search.setPageSize(pageSize);
		search.setOrder(search.getOrder());
		List<Product> list=new ArrayList<Product>();
		// Business logic 수행
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		Cookie cookie= new Cookie("history", history);
		cookie.setPath("/");
		response.addCookie(cookie);
		
	if (history!="") {
		
	
		String[] h =history.split(",");
		
		for (int i = 0; i < h.length; i++) {
			
				
				Product cookieProduct=productService.getProduct(Integer.parseInt(h[i]));
			
			list.add(productService.getProduct(Integer.parseInt(h[i])));
			
		}
	}
		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		model.addAttribute("cookieList", list);
	
		
		return "forward:/product/listProduct.jsp";
	}
}