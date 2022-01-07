package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    //多条件分页查询
    List<Clue> queryAllByTermClueList(Map<String, Object> map);

    //查询总条数
    Integer queryCountClue(Map<String, Object> map);

    //批量删除
    int deleteAllPrimaryKey(String[] id);
    //主键多表查询
    Clue selectdetailClueByPrimaryKey(String id);

}
