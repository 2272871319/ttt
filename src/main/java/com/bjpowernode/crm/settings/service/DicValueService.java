package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

/**
 * ClassName:DicValueService
 * Package:com.bjpowernode.crm.settings.service
 * Description:
 * author:王
 */
public interface DicValueService {
    /**
     * 查询全部表
     * @return
     */
    List<DicValue> queryAllDicValueList();

    /**
     * 保存数据
     * @return
     */
    int saveCreateDicValue(DicValue dicValue);

    /**
     * 根据主键查询
     * @param id
     * @return
     */
    DicValue editDicValue(String id);

    /**
     * 更新数据
     * @param dicValue
     * @return
     */
    int saveEditDicValue(DicValue dicValue);

    /**
     * 批量删除
     * @param id
     * @return
     */
    int deleteDicValueBtn(String[] id);
}
