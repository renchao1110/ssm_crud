package com.rc.crud.bean;

import java.util.HashMap;
import java.util.Map;

public class Message {
    private String state;
    private String msg;
    private Map<String,Object> map = new HashMap<>();


    public static Message success(){
        Message m = new Message();
        m.setState("200");
        m.setMsg("执行成功");
        return m;
    }

    public static Message fail(){
        Message m = new Message();
        m.setState("500");
        m.setMsg("执行失败");
        return m;
    }

    public Message add(String key,Object value){
        this.getMap().put(key, value);
        return this;
    }


    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getMap() {
        return map;
    }

    public void setMap(Map<String, Object> map) {
        this.map = map;
    }

}
