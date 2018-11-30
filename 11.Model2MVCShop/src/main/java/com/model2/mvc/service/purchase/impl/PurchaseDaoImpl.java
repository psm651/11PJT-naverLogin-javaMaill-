package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;


//==> 회원관리 DAO CRUD 구현
@Repository("purchaseDaoImpl")
public class PurchaseDaoImpl implements PurchaseDao{
	
	///Field
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public PurchaseDaoImpl(){
		System.out.println(this.getClass());
	}
	
	@Override
	public void updateTranCode(Purchase purchase) throws Exception {
		sqlSession.update("PurchaseMapper.updateTranCode", purchase);
		
	}
	@Override
	public void updatePurchase(Purchase purchase) throws Exception {
		sqlSession.update("PurchaseMapper.updatePurchase", purchase);
		
	}
	@Override
	public Purchase findPurchase(int tranNo) throws Exception {
		
		return sqlSession.selectOne("PurchaseMapper.getPurchase", tranNo);
	}
	@Override
	public void insertPurchase(Purchase purchase) throws Exception {
		sqlSession.insert("PurchaseMapper.addPurchase", purchase);		
	}
	@Override
	public List<Purchase> getPurchaseList(Search search, String buyerId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("search", search);
		map.put("buyerId", buyerId);
		
		return sqlSession.selectList("PurchaseMapper.getPurchaseList", map);
	}

	@Override
	public Purchase findPurchase2(int prodNo) throws Exception {
	System.out.println("findPurchase2들어왓다");
		return sqlSession.selectOne("PurchaseMapper.getPurchase2", prodNo);
	}
	@Override
	public int getTotalCount(String userId) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.getTotalCount", userId);
	}
	/*

	public List<User> getProductList(Search search) throws Exception {
		return sqlSession.selectList("ProductMapper.getProductList", search);
	}
	
	// 게시판 Page 처리를 위한 전체 Row(totalCount)  return
	*/

	@Override
	public List<Purchase> getPurchaseList2(Search search) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("search", search);
		
		return sqlSession.selectList("PurchaseMapper.getPurchaseList2", map);
	}

	@Override
	public int getTotalCount2() throws Exception {
		
		return sqlSession.selectOne("PurchaseMapper.getTotalCount2");
	}
}