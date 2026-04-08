*** Settings ***
Library          AppiumLibrary
Library          OperatingSystem
Library          SauceLib.py

*** Variables ***
${SAUCE_URL}             https://ondemand.us-west-1.saucelabs.com:443/wd/hub
${TEST_URL}              https://www.google.es
${SESSION_INDEX}         1

*** Test Cases ***
Open Safari Test
    [Setup]    Setup Sauce Options
    Create Custom Sauce Session
    Go To URL    ${TEST_URL}
    [Teardown]    Close Application

*** Keywords ***
Setup Sauce Options
    ${USER}=    Get Environment Variable    SAUCE_USERNAME
    ${KEY}=     Get Environment Variable    SAUCE_ACCESS_KEY

    &{SAUCE_OPTS}=  Create Dictionary
    ...    build=High-Resilience-Robot-Test-improved-redirect-0
    ...    name=Robot-Run-${SESSION_INDEX}
    ...    username=${USER}
    ...    accessKey=${KEY}

    &{CAPS}=    Create Dictionary
    ...    platformName=iOS
    ...    browserName=Safari
    ...    appium:platformVersion=17.0
    ...    appium:deviceName=iPhone Simulator
    ...    appium:automationName=XCUITest
    ...    sauce:options=${SAUCE_OPTS}

    Set Test Variable    &{CAPS}

Create Custom Sauce Session
    # Using your Python logic instead of Open Application
    ${session_id}=    Open Session With Custom Config    ${SAUCE_URL}    ${CAPS}
    Log    Started Sauce Session: ${session_id}