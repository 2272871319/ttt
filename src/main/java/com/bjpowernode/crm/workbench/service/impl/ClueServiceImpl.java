package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.mapper.ClueMapper;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ClueServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;


    /**
     * 多条件分页查询
     * @param map
     * @return
     */
    @Override
    public PaginationVO<Clue> queryAllByTermClueList(Map<String, Object> map) {
        PaginationVO<Clue> objectPaginationVO = new PaginationVO<>();

        //拿到全部数据装到list    再装到分页模型
        List<Clue> clueList = clueMapper.queryAllByTermClueList(map);
        objectPaginationVO.setDataList(clueList);

        //拿到总条数
        Integer pageRows = clueMapper.queryCountClue(map);
        objectPaginationVO.setTotal(pageRows);

        return objectPaginationVO;
    }

    /**
     * 线索中创建保存数据
     * @param clue
     * @return
     */
    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertSelective(clue);
    }

    /**
     * 根据id单表查询
     * @param id
     * @return
     */
    @Override
    public Clue editClue(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    /**
     * 批量删除
     * @param id
     * @return
     */
    @Override
    public int deleteAll(String[] id) {
        return clueMapper.deleteAllPrimaryKey(id);
    }

    /**
     * 更新保存
     * @param clue
     * @return
     */
    @Override
    public int saveUpdateClue(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public Clue detailClue(String id) {
        return clueMapper.selectdetailClueByPrimaryKey(id);
    }

}
