package com.bjpowernode.crm.commons.utils;

import java.util.List;

/**
 * ClassName:PaginationVO
 * Package:com.bjpowernode.crm.commons.utils
 * Description:
 * author:王
 */
public class PaginationVO<T> {

    private List dataList;

    private Integer total;


    public List getDataList() {
        return dataList;
    }

    public void setDataList(List dataList) {
        this.dataList = dataList;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
