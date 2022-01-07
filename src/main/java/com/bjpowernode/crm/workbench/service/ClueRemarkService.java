package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * ClassName:ClueRemarkService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ClueRemarkService {
    /**
     * 查询备注表
     * @param id
     * @return
     */
    List<ClueRemark> queryAllClueRemarkById(String id);

    /**
     * 更新备注
     * @param clueRemark
     * @return
     */
    int updateRemark(ClueRemark clueRemark);

    /**
     * 保存备注
     * @param clueRemark
     * @return
     */
    int saveDetailRemark(ClueRemark clueRemark);

    /**
     * 删除备注按钮
     * @param id
     * @return
     */
    int deleteDiv(String id);
}
