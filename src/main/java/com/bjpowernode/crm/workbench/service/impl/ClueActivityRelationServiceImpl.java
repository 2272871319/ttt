package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.mapper.ClueActivityRelationMapper;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ClueActivityRelationServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int deleteRelation(Map<String, Object> map) {
        return clueActivityRelationMapper.deleteRelation(map);
    }

    @Override
    public int saveBundActivity(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.saveBundActivity(list);
    }


}
