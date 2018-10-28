*** Settings ***
Documentation     This test assumes that the infra and debug stack is running.Since this is a SIDT template we believe the debug setup ist part of the provided value hence testing the debug frontend is part of the job
Library           SeleniumLibrary

*** Variables ***
${SERVICE_NAME1}    ufp-sidt-example-app
${SERVICE_PORT1}    3000

*** Test Cases ***
Test Service Index Todos
    [Documentation]    testing index of todos in browser
    [Tags]    frontend    service
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}/todos    Chrome
    Wait Until Page Contains    [
    Capture Page Screenshot    ServiceTodos.png

Test Service Index Todos Entry
    [Documentation]    testing index of todos in browser
    [Tags]    frontend    service
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}/todos/1    Chrome
    Capture Page Screenshot    ServiceTodos.png

      
