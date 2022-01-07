package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Tran;

/**
 * ClassName:TranService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface TranService {
    /**
     * 线索转化
     * @param tran
     * @return
     */
    int saveConvertByTran(Tran tran);


}
