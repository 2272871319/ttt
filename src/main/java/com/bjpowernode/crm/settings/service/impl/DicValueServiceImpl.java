package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:DicValueServiceImpl
 * Package:com.bjpowernode.crm.settings.service.impl
 * Description:
 * author:王
 */
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryAllDicValueList() {
        return dicValueMapper.queryAllDicValueList();
    }

    @Override
    public int saveCreateDicValue(DicValue dicValue) {
        return dicValueMapper.insertSelective(dicValue);
    }

    @Override
    public DicValue editDicValue(String id) {
        return dicValueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditDicValue(DicValue dicValue) {
        return dicValueMapper.updateByPrimaryKeySelective(dicValue);
    }

    @Override
    public int deleteDicValueBtn(String[] id) {
        return dicValueMapper.deleteDicValueBtn(id);

    }


}
