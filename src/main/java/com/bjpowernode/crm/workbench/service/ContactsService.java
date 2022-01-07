package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

/**
 * ClassName:ContactsService
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Description:
 * author:王
 */
public interface ContactsService {
    /**
     * 查询联系人和客户id
     * @param id
     * @return
     */
    Contacts selectTwoId(String id);
}
