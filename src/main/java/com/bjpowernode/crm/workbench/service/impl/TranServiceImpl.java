package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * ClassName:TranServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;

    @Override
    public int saveConvertByTran(Tran tran) {
        return tranMapper.insertSelective(tran);
    }
}
