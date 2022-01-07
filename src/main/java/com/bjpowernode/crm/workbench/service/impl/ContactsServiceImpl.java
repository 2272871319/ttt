package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * ClassName:ContactsServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;

    /**
     * 查询联系人和客户id
     * @param id
     * @return
     */
    @Override
    public Contacts selectTwoId(String id) {
        return contactsMapper.selectByTwoId(id);
    }
}
