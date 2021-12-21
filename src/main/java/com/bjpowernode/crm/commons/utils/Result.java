package com.bjpowernode.crm.commons.utils;

import com.bjpowernode.crm.commons.contants.Constants;

import java.util.HashMap;

/**
 * ClassName:Result
 * Package:com.bjpowernode.crm.commons.utils
 * Description:
 * author:王
 */
public class Result extends HashMap<String,Object> {
    /**
     * 认证成功
     * @return
     */
    public static Result success(){
        Result result = new Result();
        result.put(Constants.RETURN_CODE, Constants.RETURN_SUCCESS);
        return result;
    }

    /**
     * 认证失败
     * @param string
     * @return
     */
    public static Result fail(String string){
        Result result = new Result();
        result.put(Constants.RETURN_CODE, Constants.RETURN_FAIL);
        result.put(Constants.RETURN_MESSAGE, string);
        return result;
    }
}
