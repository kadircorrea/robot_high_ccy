*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         Collections

*** Variables ***
${SAUCE_URL}              https://ondemand.us-west-1.saucelabs.com:443/wd/hub
${TEST_URL}               https://www.google.es
# Using the naming convention from your second script
${browser}                ${BROWSER_NAME}
${BROWSER_NAME}           chrome
${BROWSER_VERSION}        latest
${PLATFORM_NAME}          Windows 10

*** Test Cases ***
Open Browser Test
    [Setup]    Setup Sauce Capabilities
    Open Sauce Browser
    Go To    ${TEST_URL}
    [Teardown]    End Session

*** Keywords ***
Setup Sauce Capabilities
    ${USER}=    Get Environment Variable    SAUCE_USERNAME
    ${KEY}=     Get Environment Variable    SAUCE_ACCESS_KEY

    &{SAUCE_OPTS}=  Create Dictionary
    ...    build=TEST-SELENIUM-BUILD
    ...    name=Browser-Run-TEST
    ...    username=${USER}
    ...    accessKey=${KEY}

    Set Test Variable    &{SAUCE_OPTS}

Open Sauce Browser
    # Updated to use the modern 'options' syntax like your second script
    Open Browser
    ...    remote_url=${SAUCE_URL}
    ...    options=set_capability("sauce:options", ${SAUCE_OPTS}); platform_name="${PLATFORM_NAME}"; browser_version="${BROWSER_VERSION}"

End Session
    # Reporting result to Sauce Labs dashboard
    Run Keyword If    '${TEST_STATUS}'== 'PASS'    Execute Javascript    sauce:job-result=passed
    ...    ELSE    Execute Javascript    sauce:job-result=failed
    Close Browser