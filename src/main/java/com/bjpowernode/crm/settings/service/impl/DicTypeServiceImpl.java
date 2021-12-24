package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.mapper.DicTypeMapper;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:DicTypeServiceImpl
 * Package:com.bjpowernode.crm.settings.service.impl
 * Description:
 * author:王
 */
@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    DicTypeMapper dicTypeMapper;
    @Override
    public List<DicType> queryAllDicTypeList() {
        return dicTypeMapper.queryAllDicTypeList();
    }

    @Override
    public DicType querydicTypeByCode(String code) {
        return dicTypeMapper.selectByPrimaryKey(code);
    }

    @Override
    public int saveCreateDicType(DicType dicType) {
        return dicTypeMapper.insertSelective(dicType);
    }

    @Override
    public int saveEditDicType(DicType dicType) {

        return dicTypeMapper.updateByPrimaryKeySelective(dicType);
    }

    @Override
    public int deleteDicType(String[] code) {
        return dicTypeMapper.deleteDicType(code);
    }
}
