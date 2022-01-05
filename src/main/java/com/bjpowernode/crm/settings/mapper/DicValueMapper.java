package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);

    /**
     * 查询全部数据
     * @return
     */
    List<DicValue> queryAllDicValueList();

    /**\
     * 批量删除
     * @param id
     * @return
     */
    int deleteDicValueBtn(String[] id);

    /**
     * 查询线索来源和线索状态
     * @param typeCode
     * @return
     */
    List<DicValue> selectBySourceAndState(String typeCode);
}
