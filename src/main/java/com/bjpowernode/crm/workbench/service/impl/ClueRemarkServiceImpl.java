package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ClueRemarkServiceImpl
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    /**
     * 根据id查找备注
     * @param id
     * @return
     */
    @Override
    public List<ClueRemark> queryAllClueRemarkById(String id) {
        return clueRemarkMapper.queryAllClueRemarkById(id);
    }

    /**
     * 更新备注
     * @param clueRemark
     * @return
     */
    @Override
    public int updateRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }

    /**
     * 保存备注
     * @param clueRemark
     * @return
     */
    @Override
    public int saveDetailRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertSelective(clueRemark);
    }

    /**
     * 删除备注
     * @param id
     * @return
     */
    @Override
    public int deleteDiv(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }
}
