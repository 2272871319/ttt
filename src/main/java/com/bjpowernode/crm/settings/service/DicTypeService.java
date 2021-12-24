package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

/**
 * ClassName:DicTypeService
 * Package:com.bjpowernode.crm.settings.service
 * Description:
 * author:王
 */
public interface DicTypeService {
    /**
     * 获取所有字典类型
     * @return
     */
    List<DicType> queryAllDicTypeList();

    /**
     * 根据编码查看字典是否有重复
     * @param code
     * @return
     */
    DicType querydicTypeByCode(String code);
}
