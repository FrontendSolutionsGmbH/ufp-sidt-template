*** Settings ***
Documentation     This test assumes that the infra and debug stack is running
Library           SeleniumLibrary

*** Variables ***
${SERVICE_NAME1}    development-overview
${SERVICE_PORT1}    3000

*** Test Cases ***
Test Debug Setup
    [Documentation]    Since this is a SIDT template we believe the debug setup ist part of the provided value hence testing the debug frontend is part of the job
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}    Chrome
    Wait Until Page Contains    UFP-SIDT
    Capture Page Screenshot    ScreenshotDebugEntryPoint.png
    Click Element    PhpMyAdmin
    Sleep    5s
    Capture Page Screenshot    PhpAdmin.png
