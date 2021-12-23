package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SettingsIndexController {
    @RequestMapping("/settings/index.do")
    public String index(){
        return "settings/index";
    }

    @RequestMapping("/settings/dictionary/index.do")
    public String dicIndex(){

        return "settings/dictionary/index";
    }
}
