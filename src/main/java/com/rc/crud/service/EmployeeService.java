package com.rc.crud.service;

import com.rc.crud.bean.Employee;
import com.rc.crud.bean.EmployeeExample;
import com.rc.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("employeeService")
public class EmployeeService {
    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getAll() {
        return employeeMapper.selectByExamplewithDept(null);
    }


    public void saveEmp(Employee emp) {
        employeeMapper.insertSelective(emp);
    }

    public boolean checkEmp(String empName) {
        EmployeeExample ee = new EmployeeExample();
        EmployeeExample.Criteria criteria = ee.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(ee);
        return count==0;
    }

    public Employee getEmpById(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteEmp(Integer empId) {
        employeeMapper.deleteByPrimaryKey(empId);
    }

    public void deleteBatch(List<Integer> list_id) {
        EmployeeExample e = new EmployeeExample();
        EmployeeExample.Criteria criteria = e.createCriteria();
        criteria.andEmpIdIn(list_id);
        employeeMapper.deleteByExample(e);
    }
}
