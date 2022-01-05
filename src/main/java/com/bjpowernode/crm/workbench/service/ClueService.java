package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ClueService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ClueService {
    /**
     * 多条件分页查询
     * @param map
     * @return
     */
    PaginationVO<Clue> queryAllByTermClueList(Map<String, Object> map);

    /**
     * 线索中创建保存数据
     * @param clue
     * @return
     */
    int saveCreateClue(Clue clue);

    /**
     * 根据id查询
     * @param id
     * @return
     */
    Clue editClue(String id);
}
