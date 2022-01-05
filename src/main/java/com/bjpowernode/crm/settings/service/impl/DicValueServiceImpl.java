package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundListOperations;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

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
    @Autowired
    private RedisTemplate redisTemplate;

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

    /**
     * 页面导入查询下拉框 线索来源和线索状态
     * @param typeCode
     * @return
     */
    @Override
    public List<DicValue> queryAllDicValueSourceAndState(String typeCode) {
        //从redis中读取缓存
        BoundListOperations boundListOperations = redisTemplate.boundListOps(typeCode);
        List<DicValue> dicValueList = boundListOperations.range(0, -1);

        if (dicValueList == null || dicValueList.size() == 0){
            dicValueList = dicValueMapper.selectBySourceAndState(typeCode);
            //把数据存到数据库
            for (DicValue dicValue : dicValueList) {
                boundListOperations.leftPush(dicValue);
            }
            //设置失效时间
            boundListOperations.expire(DateUtils.getRemainSecondsOneDay(new Date()), TimeUnit.SECONDS);
        }
        return dicValueList;
    }


}
