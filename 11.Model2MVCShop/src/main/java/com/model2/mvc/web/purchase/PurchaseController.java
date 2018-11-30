package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserService;
                                                                                                                                                                                                                                   

//==> 회원관리 Controller
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {
	

	///Field
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	//setter Method 구현 않음
		
	public PurchaseController(){
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
	
	//수정해야한다
	@RequestMapping(value="addPurchase",method=RequestMethod.GET)
	public ModelAndView addPurchase(@RequestParam("prodNo") int prodNo) throws Exception {

		System.out.println("/purchase/addPurchase==GET방식");
	
		Purchase purchase = purchaseService.getPurchase2(prodNo);
		Product product = productService.getProduct(prodNo);
		product.setProTranCode("1");
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("forward:/purchase/addPurchaseView.jsp");
		modelAndView.addObject("purchase", purchase);
		System.out.println("GET방식으로 넘어가는 최종펄쳐스"+purchase);
		modelAndView.addObject("product", product);
		
		
	
		return modelAndView;
	}
	
	@RequestMapping(value="addPurchase",method=RequestMethod.POST)
	public ModelAndView addPurchase( @ModelAttribute("purchase") Purchase purchase, @RequestParam("buyerId") String buyerId,
			@RequestParam("prodNo") int prodNo) throws Exception {

		System.out.println("/purchase/addPurchase==POST방식");
		//Business Logic
		
		purchase.setBuyer(userService.getUser(buyerId));
		purchase.setPurchaseProd(productService.getProduct(prodNo));
		purchase.setTranCode("1");
		
		Product product=new Product();
		product=productService.getProduct(prodNo);
		
		int stock=(product.getStock()-purchase.getPurchaseStock());
		product.setStock(stock);
		
		productService.updateProduct(product);
		purchaseService.addPurchase(purchase);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/purchase/addPurchase.jsp");
		modelAndView.addObject("purchase", purchase);
		
		
		
		return modelAndView;
	}
	
	@RequestMapping(value = "getPurchase", method = RequestMethod.GET)
	public ModelAndView getPurchase( @RequestParam("tranNo") int tranNo) throws Exception {
		
		System.out.println("/purchase/getPurchase get방식!");
		//Business Logic
		Purchase purchase = purchaseService.getPurchase(tranNo);
		// Model 과 View 연결
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("forward:/purchase/getPurchase.jsp");
		modelAndView.addObject("purchase", purchase);
		
		return modelAndView;
	}

	@RequestMapping(value = "updatePurchase", method = RequestMethod.GET)
	public ModelAndView updatePurchase( @RequestParam("tranNo") int tranNo ) throws Exception{

		System.out.println("/purchase/updatePurchase");
		//Business Logic
		Purchase purchase=purchaseService.getPurchase(tranNo);
		// Model 과 View 연결
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("forward:/purchase/updatePurchaseView.jsp");
		modelAndView.addObject("purchase", purchase);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "updatePurchase", method = RequestMethod.POST)
	public ModelAndView updatePurchase( @ModelAttribute("purchase") Purchase purchase, @RequestParam("tranNo") int tranNo ) throws Exception{

		System.out.println("/purchase/updatePurchase");
		//Business Logic
		
		purchaseService.updatePurcahse(purchase);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("redirect:/purchase/getPurchase?tranNo="+tranNo);
		
		return modelAndView;
	}
	
	@RequestMapping(value="listPurchase")
	public ModelAndView listPurchase( @ModelAttribute("search") Search search,@RequestParam("currentPage") int currentPage, HttpSession session) throws Exception{
		
		System.out.println("/purchase/listPurchase");
		String buyerId = ((User)session.getAttribute("user")).getUserId();
		if(search.getCurrentPage() ==0||currentPage ==0){
			search.setCurrentPage(1);
		}else {
			search.setCurrentPage(currentPage);	
		}
		
		search.setPageSize(pageSize);
		search.setOrder(search.getOrder());
		
		// Business logic 수행
		Map<String , Object> map=purchaseService.getPurchaseList(search, buyerId);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		System.out.println("@@@@@@@@@@@@@@@@@@@@"+map.get("list"));
		// Model 과 View 연결
		ModelAndView modelAndView= new ModelAndView();
		modelAndView.setViewName("forward:/purchase/listPurchase.jsp");
		modelAndView.addObject("list", map.get("list"));
		modelAndView.addObject("resultPage", resultPage);
		modelAndView.addObject("search", search);
	
		
		return modelAndView;
	}
	@RequestMapping(value="listPurchase2")
	public ModelAndView listPurchase2( @ModelAttribute("search") Search search,@RequestParam("currentPage") int currentPage) throws Exception{
		
		System.out.println("/purchase/listPurchase2");
		if(search.getCurrentPage() ==0||currentPage ==0){
			search.setCurrentPage(1);
		}else {
			search.setCurrentPage(currentPage);	
		}
		
		search.setPageSize(pageSize);
		search.setOrder(search.getOrder());
		
		// Business logic 수행
		Map<String , Object> map=purchaseService.getPurchaseList2(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		// Model 과 View 연결
		ModelAndView modelAndView= new ModelAndView();
		modelAndView.setViewName("forward:/purchase/listPurchase2.jsp");
		modelAndView.addObject("list", map.get("list"));
		modelAndView.addObject("resultPage", resultPage);
		modelAndView.addObject("search", search);
	
		
		return modelAndView;
	}
	
	@RequestMapping(value="updateTranCodeActionByProd",method=RequestMethod.GET)
	public ModelAndView updateTranCodeActionByProd(@ModelAttribute("purchase") Purchase purchase, @RequestParam("prodNo") int prodNo,
			@RequestParam("tranCode") String tranCode,@RequestParam("currentPage") int currentPage, @RequestParam("userId") String userId) throws Exception{

		System.out.println("/product/updateTranCodeActionByProd");
		//Business Logic
		
		Product purchaseProd= productService.getProduct(prodNo);

		purchase.setPurchaseProd(purchaseProd);
		purchase.setBuyer(userService.getUser(userId));
		purchase.setTranCode(tranCode);
		purchaseService.updateTranCode(purchase);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("redirect:/purchase/listPurchase2?currentPage="+currentPage);
		
		return modelAndView;
	}
	
	@RequestMapping(value="updateTranCode",method=RequestMethod.GET)
	public ModelAndView updateTranCode(@ModelAttribute("purchase") Purchase purchase,@RequestParam("currentPage") int currentPage, @RequestParam("tranNo") int tranNo,
			@RequestParam("tranCode") String tranCode,HttpSession session ) throws Exception{

		System.out.println("/purchase/updateTranCode");
		//Business Logic
		
		purchase=purchaseService.getPurchase(tranNo);
		purchase.setTranCode(tranCode);
		purchaseService.updateTranCode(purchase);
		ModelAndView modelAndView = new ModelAndView();
		if (session.getAttribute("user").equals("admin")) {
			modelAndView.setViewName("redirect:/product/listProduct?menu=manage");
		} else
			modelAndView.setViewName("redirect:/purchase/listPurchase?currentPage="+currentPage);
		
		return modelAndView;
	}
}