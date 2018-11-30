package com.model2.mvc.service.purchase;

import java.util.List;
import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;

public interface PurchaseDao {

	public void updateTranCode(Purchase purchase) throws Exception;
	
	public void updatePurchase(Purchase purchase) throws Exception;
	
	public Purchase findPurchase(int tranNo) throws Exception;
	
	public Purchase findPurchase2(int prodNo) throws Exception;
	
	public void insertPurchase(Purchase purchase) throws Exception;
	
	public List<Purchase> getPurchaseList(Search search, String buyerId) throws Exception;
	
	public List<Purchase> getPurchaseList2(Search search) throws Exception;
	
	
	public int getTotalCount(String userId) throws Exception;
	public int getTotalCount2() throws Exception;
}
