package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;
import com.model2.mvc.service.purchase.PurchaseService;

@Service("purchaseServiceImpl")
public class PurchaseServiceImpl implements PurchaseService {

	
	@Autowired
	@Qualifier("purchaseDaoImpl")
	private PurchaseDao purchaseDao;

	public void setPurchaseDao(PurchaseDao purchaseDao) {
		this.purchaseDao = purchaseDao;
	}

	@Override
	public void addPurchase(Purchase purchase) throws Exception {
		purchaseDao.insertPurchase(purchase);
	}

	//@Override
	public Purchase getPurchase(int tranNo) throws Exception {
		return purchaseDao.findPurchase(tranNo);
	}

	//@Override
	public Purchase getPurchase2(int prodNo) throws Exception {
	
		return purchaseDao.findPurchase2(prodNo);
	}

	//@Override
	public Map<String, Object> getPurchaseList(Search search, String buyerId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list",purchaseDao.getPurchaseList(search, buyerId));
		map.put("totalCount", purchaseDao.getTotalCount(buyerId));
		return map;
	}

	//@Override
	public Map<String, Object> getSaleList(Search search) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	//@Override
	public void updatePurcahse(Purchase purchase) throws Exception {

		purchaseDao.updatePurchase(purchase);
	}

	//@Override
	public void updateTranCode(Purchase purchase) throws Exception {
		purchaseDao.updateTranCode(purchase);

	}

	@Override
	public Map<String, Object> getPurchaseList2(Search search) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list",purchaseDao.getPurchaseList2(search));
		map.put("totalCount", purchaseDao.getTotalCount2());
		return map;
	}

}
