---
title: REL-ID SDK

language_tabs:
  - java: Java
  - objective_c: Objective C
  - cpp: C++
<!--  - c: ANSI C -->

toc_footers:
  - <a href='http://www.uniken.com'><u>UNIKEN</u></a>

<!--includes:
  - errors-->

search: true
---

# Introduction
<aside class="notice"><b><u>Disclaimer</u></b> -
<br>
This specification is a <u>working pre-release draft</u>.
<br>
Last updated on <u>Thursday, 15th May 2018</u>
</aside>

Welcome to the REL-ID API !

REL-ID is a distributed digital trust platform that connects things - people, networks, devices, applications - securely. It creates a closed, private, massively scalable, app-to-app networking ecosystem to protect enterprise applications and data from unauthorized and fraudulent access, and tampering.

The REL-ID API enables applications to be written to leverage the path-breaking security REL-ID provides. The API SDK is shipped with client-side API libraries, reference implementations and documentation, as well as the server-side REL-ID platform.

The core API is implemented in ANSI C, and has wrappers/bindings for Java (Android), Objective-C (iOS, OSX) and C++ (Windows Phone, Windows Desktop).

<aside class="notice">JavaScript bindings for hybrid application frameworks will be made available in future</aside>

<aside class="notice"><b><u>API-client</u></b><br>
Throughout this documentation, the term <u>API-client</u> refers to an application that embeds and uses the REL-ID API within itself.
</aside>

At a high level, the REL-ID API provides the following features that enable applications to leapfrog ahead in terms of securing themselves - mutual identity and authentication, device fingerprinting and binding, privacy of data, and the digital network adapter (aka DNA). An additional feature of capability to pause and resume the API runtime, on demand, has been provided particularly keeping mobile smartphone device platforms in mind.

## Mutual identity and authentication

<u>Relative Identity</u> (or <u>REL-ID</u> for short) is a mutual identity that encapsulates/represents uniquely, the relationship between 2 parties/entities. This mutual identity is mathematically split in two, and one part each is distributed securely to the communicating parties. The identity of each end-point party/entity is thus relative to the identity of the other end-point party/entity. REL-ID can be used to represent the relationship between user and app, user and user, or app and other app, thus providing a holistic digital identity model.

The protocol handshake that authenticates the REL-ID between 2 parties/entities is RMAK which is short form for <b><u>R</u>EL-ID <u>M</u>utual <u>A</u>uthentication and <u>K</u>ey-exchange</b>. It is a unique and patented protocol handshake that enables MITM-resistant, true mutual authentication. As specified in the name, key-exchange is a by-product of a successful RMAK handshake and the exchanged keys are used for downstream privacy of communications over the authenticated channel.

<aside class="notice"><i><b><u>Agent REL-ID</u></b> and <b><u>User REL-ID</u></b></i>
<li>An <u><b>Agent REL-ID</b></u> is used to represent the relationship between software application and the REL-ID platform backend.
<li>An <u><b>User REL-ID</b></u> is used to represent the relationship between end-user of the application and the REL-ID platform backend.
<br>
<i>Note that the REL-ID platform backend represents the enterprise.</i>
</aside>

## Device fingerprinting and binding

Every end-point computing device has a number of unique identities associated with it. This includes hardware OEM identities, as well as software identities at both OS platform and application software level. The end-point device fingerprint is created by collecting these various identities, and using them together to uniquely identify it.

The REL-ID platform's multi-factor authentication (MFA) is implemented by binding the device fingerprint/identity with the REL-ID of the user/app, thus ensuring that REL-ID-based access is provided only from whitelisted end-point devices (those with identities/fingerprints bound to the relevant REL-IDs).

## Access to backend enterprise services

After successful mutual authentication between REL-ID API client-side and REL-ID platform backend (the REL-ID <b>Authentication Gateway</b>), the <b>REL-ID Digital Network Adapter</b> (or <b>RDNA</b> for short) is setup inside the API runtime for enabling secure communications of the API-client application with its enterprise backend services. These services are hidden behind the REL-ID <b>Access Gateway(s)</b> and are accessible ONLY via the RDNA, which possesses the capability to tunnel/relay/patch through application traffic between the client app and its backend services via an Access Gateway.

The backend coordinates of the enterprise services that are accessible for a given software agent REL-ID or user REL-ID are configured into the REL-ID platform on the REL-ID <b>Gateway Manager</b> console. During this configuration, these coordinates are supplied in the form that they are reachable from the REL-ID Access Gateway(s), i.e. using the internally accessible coordinates (IP addresses and port numbers).

The RDNA provides multiple mechanisms to enable this tunneling of traffic - a HTTP proxy facade, and any number of forwarded TCP ports corresponding to backend enterprise service TCP coordinates.


Facade | Description
------ | -----------
HTTP&nbsp;Proxy | The API-client uses a standard HTTP library to make its HTTP requests, instructing the library to to make the request via the specified HTTP proxy running on local loopback adapter (127.0.0.1/::1).
Forwarded&nbsp;Port | The API client connects directly to a locally present port which represents the backend enterprise service coordinate.

## Privacy of Data

One of the important functionalities the API SDK provides is to encrypt and decrypt application data, on demand. The following scopes of privacy are provided - session-scope, device-scope, user-scope and agent-scope. In all cases, the API-client application can additionally specify cipher-specs for the encryption algorithm and mode to use, as well as specify its own salting vector (or IV).

Privacy Scope | Description
------------- | -----------
<b>Session</b> | The keys used are specific to the REL-ID session and valid for the duration of the session. These keys are primarily used to secure the privacy of data in transit between the API-client application and the REL-ID DNA, as well as between the API-client application and its backend services.
<b>Device</b> | The keys used are specific to the end-point device. These keys are primarily used by the API-client application to secure the privacy of data that the API-client application might want to persist on the device.
<b>User</b> | The keys used are specific to the user.
<b>Agent</b> | The keys used are specific to the agent (i.e. the application using the API)

## Pause-resume of API runtime

Applications written for mobile platforms like Android, iOS and WindowsPhone generally require to handle the 'OS is pausing your application' and the 'OS is resuming your application' events.

The REL-ID API includes ```PauseRuntime``` and ```ResumeRuntime``` routines that terminate-and-save the runtime state and restore-and-reinitialize the runtime state respectively:

Routine | Description
------- | -----------
<b>PauseRuntime</b> | Routine that terminates the API runtime, saves a <u><i>private</i></u> copy of the relevant data structures, and returns an encoded dump of the saved information as a null-terminated string.<br><br>When an API-client application is asked to <i>pause</i> itself, it anyway saves its runtime state in a bundle of some kind and persists it (either using OS services, or separately where it knows to look when the application is resumed)<br>At this point, the API-client application must also invoke the ```PauseRuntime``` routine and save the returned string as well.
<b>ResumeRuntime</b> | Routine that accepts a previously saved <u><i>private</i></u> copy of the API runtime, and restores the API runtime back to the saved state while validating some of the saved state (like session information - validity/life, other information).<br><br>When an API-client application is asked to <i>resume</i> itself, it anyway restores its own runtime status from a previously persisted information bundle of some kind<br><b>BEFORE</b> it does that, it should first restore the previously persisted <i><u>private</u></i> copy of the API runtime state (from a previously executed ```PauseRuntime```) and invoke the ```ResumeRuntime``` routine passing this state information in to it.

## Non-blocking API

The API is written with non-blocking(asynchronous) interactions in mind - none of the API routines will block for any kind of network I/O.

When an API routine requires to perform network I/O with backend services in order to service the API-client, that I/O is delegated to the DNA which is part of the API runtime, and the results are communicated back via callback routines supplied by the API-client. The DNA itself uses non-blocking I/O for all the network communication it performs.

 * Each API routine returns immediately without blocking on any network I/O.
 * Where applicable, API call results are communicated asynchronously via API-client supplied callback routines.

# Getting started

The following table lists and briefly describes the different interactions with the REL-ID API:

Interaction | Description
----------- | -----------
<u>Initialization</u> | Initialize the API runtime by establishing a REL-ID session and setting up the API runtime, including a DNA instance.
<u>User&nbsp;Identity</u> | Take the REL-ID session established during <u>Initialization</u> and take it through a bunch of states via this bunch of API routines, to the final SECONDARY (user REL-ID authenticated) state.
<u>Access</u> | Provide the API-client application with connectivity to its backend enterprise services via the DNA in the API runtime - to those backend services the REL-ID session has access to.
<u>Data&nbsp;Privacy</u> | Provide the API-client application with routines to encrypt and decrypt data, with keys at different scopes, without worrying about key-management.
<u>Pause&nbsp;Resume</u> | Pause saves the API runtime state and shuts down the API runtime. Subsequently, resume restores the runtime state and re-initialize the API runtime.
<u>Terminate</u> | Clean shutdown of the API runtime.

<aside class="notice"><i>The <b><u>User-Identity</u></b> interaction</i> -
<br>
is applicable only when an API-client application uses the REL-ID API for the purpose of its user identity as well. This part of the API is called the REL-ID Advanced API. The rest of the interactions are applicable regardless (i.e. part of the Basic API). In other words, the Advanced API is nothing but the Basic API + User-Identity interaction.
</aside>

## Initialization

This interaction is governed by a single API routine (```Initialize```) invocation that sets the stage for all subsequent interactions.

Most importantly, this is the phase when the <u>API runtime establishes an agent-authenticated session with the REL-ID platform</u> backend and <u>bootstraps the DNA for subsequent connectivity with both REL-ID platform services as well as the configured backend enterprise services</u>

The following information is supplied by the API-client application to the initialization routine:

 * Agent information (available as a base64-encoded blob, upon provisioning a new agent REL-ID on a commercially licensed REL-ID Gateway Manager along with an optional device threat policy)
 * Callback methods/functions that the API runtime will use to communicate with the API-client application (status/error notifications, device context/fingerprint retrieval)
 * Network coordinates of the REL-ID Authentication Gateway (hostname/IP address and port number)
 * Privacy (encryption) specifications for the Data Privacy APIs - includes cipher specs and salt to use
 * Opaque reference to the API-client application context (never interpreted/modified by the API runtime, placeholder for application)
 * <i>If applicable</i>, proxy information for connecting through to the REL-ID Auth Gateway

<aside class="notice"><i>The <b><u>API-runtime Context</u></b></i> -
<li>While the <u>Initialize</u> API routine returns immediately, it returns an opaque pointer to the API-runtime context which must be supplied with every subsequent call to the API routines. Initialization of this returned context continues, and progress is notified to the API-client via <u>StatusUpdate</u> invocations referring to the same API-runtime context.
<li>Note that the same API-client application process/instance can create multiple API-runtime contexts (via multiple <u>Initialize</u> routine calls) to communicate with different enterprise backend service zones. However, note that this type of usage can fail if the REL-ID platform backend is not appropriately configured.
</aside>

Upon successful initialization, a agent REL-ID-authenticated session is established with the REL-ID platform backend, in a <b>PRIMARY</b> state (i.e. only the software agent has been mutually authenticated, and device has been identified). At this point the application can access backend enterprise services configured into the context of the software agent REL-ID, and not necessarily an user identity.

<aside class="notice"><i>The <b><u>Agent Information</u></b></i> -
<br>
is extremely sensitive data, since it uniquely encapsulates the mutual identity between the API-client application and the REL-ID platform backend. This information must be stored securely by the API-client application. <u>The API-client application must take measures to prevent attackers from reverse engineering this information out of its software binary/runtime</u>. For example, employ a mix of steganography and encryption to securely load and decrypt this information before initializing the REL-ID API runtime.
</aside>

## User-Identity

After successful initialization, with the REL-ID session in PRIMARY state, the application can use a bunch of API routines to authenticate the end-user operating the API-client application. This covers user REL-ID activation, binding of device identity to the user REL-ID, credentials update, automated reset of credentials, generation of some one-time-use credentials and notifications to the end-user of information requiring his/her attention/response.

Upon successful user authentication, the REL-ID session moves to a SECONDARY state (i.e. user has been authenticated).

At this point the application access backend enterprise services in the context of the authenticated user REL-ID.

<aside class="notice"><i>The <b><u>Advanced API</u></b></i> -
<br>The user-identity interaction is accessible to the API-client via an additional set of API routines that build on top of the Basic API. Along with the Basic API routines, these additional API routines constitute the <b>REL-ID Advanced API</b>
</aside>

## Access

Upon successful initialization/authentication, the ports and facades for the access to different backend enterprise services are provided to the API-runtime to setup the DNA for API-client. This information is returned to the API-runtime every time it creates a REL-ID session - which is after successful initialization (PRIMARY session) and after successful end-user authentication (SECONDARY session).

When the access configuration for a given session changes at the backend, the session is immediately invalidated. This triggers the API-runtime to either renew/recreate its session, causing it to update/refresh the access configuration.

## Data Privacy

One of the important results of successful initialization of the API-runtime, is the distribution of privacy keys at different scopes/levels (Device, Agent, Session). User-level keys are shared with the API-runtime, upon successful end-user authentication.

These keys are not directly shared with the API-client application, but are available for use with encryption and decryption of application data, via a set of privacy routines.

This functionality is not directly related to the exact method of communication between the API-client application, and its backend enterprise services. For example, an API-client application could potentially use these privacy API to encrypt data, and send the cipher-text via SMS/EMAIL/other method to its backend services, whereupon the backend service could interact with REL-ID backend systems (Integration Gateway, in particular), to decrypt and obtain the plain-text data for processing.

## Pause-Resume

### Pause
On mobile platforms, due to limited resource availability, the OS very often puts your application to sleep. When doing this, the OS gives the application a chance to save its state so that it may resume later when it is brought back to the foreground.

The pause API routine requires to be called in such an eventuality, so that the API runtime gets a opportunity to save its state and pass that state back to the API client application for saving to persistent storage on the device.

Typically the pause API routine must be last REL-ID API routine to be called, before saving the application state - along with the API runtime state.

### Resume
When a mobile application has been paused, it must invoke the pause API routine, and save the returned API runtime state information, along with its own state.

When the same application is resumed, in its own resume sequence, it must invoke the resume API routine, passing in the runtime state that it had saved earlier, so that the API can reinitialize and resume its runtime operations.

Typically the resume API routine must be first REL-ID API routine to be called, immediately after loading the previously saved application state - along with the API runtime state.

## Termination

The terminate API routine should be called during application shutdown in order to cleanly terminate the API runtime.

# Structures and Enumerations

The following subsections list down and explain the different data structures and enumerations that are provided by the REL-ID API. The API-client application developer requires to be familiar with these in order to make effective use of the REL-ID API.

## Callback routines (types, structures, interfaces)

This structure is supplied to the Initialize routine containing API-client application callback routines. These callback routines are invoked by the API runtime at different points in its execution - for updating status, for requesting the API-client application to supply information etc.

<!--
```c
/* Callback invoked by core API runtime to update API-client of state changes,
exceptions and notifications */
typedef
int
(*fn_status_update_t)
(core_status_t* pStatus);

/* Callback invoked by core API runtime to retrieve device fingerprint identity information */
typedef
int
(*fn_get_device_fingerprint_t)
(char **psDeviceFingerprint, void* pvAppCtx);

/* Callback invoked by core API runtime to get the 401 credentials*/
typedef
void
(*fn_get_credentials_t)
(void* pvAppCtx, char* psUrl, char** psUserName, char** psPassword, e_core_iwa_auth_status* status);

/* Callback invoked by core API runtime to retrieve device token identity information */
typedef
int
(*fn_get_device_token_t)
(char **psDeviceToken, void* pvAppCtx);

/* Callback invoked by core API runtime to give the http response */
typedef
void
(*fn_http_response_cb_t)
(void* pvAppCtx
, int nTunnelRequestID
, int statusCode
, unsigned char *statusMessage
, core_http_header **headers
, unsigned int nHeaders
, unsigned char *sBody
, unsigned int bodyLength
, unsigned int nErrorCode);

/* Callback invoked by core API runtime to update API-client of state changes,
exceptions and notifications */
typedef
void
(*fn_session_timeout_cb_t)
(core_status_t* pStatus);

/* Callback invoked by core API runtime to perform better sdk related
device security checks
@return E_NO_ERROR on success, otherwise failure*/
typedef
int
(*fn_threat_check_cb_t)
(char *pcThreatPolicy
, void *pvAppCtx);

/* Callback invoked by core API runtime whenever device threat policy check has failed */
typedef
void
(*fn_threat_check_status_cb_t)
(void* pvAppCtx);

/* Callback involed by the core API runtime whenever reporting sdk logs for the provided log level*/
typedef
void
(*fn_sdk_log_cb_t)
(void* pvAppCtx,
int eLogLevel,
char* pcLogData);

/* struct of callback pointers */
typedef struct {
fn_status_update_t
                pfnStatusUpdate;
fn_get_device_fingerprint_t
                pfnGetDeviceFingerprint;
fn_get_credentials_t
                pfnGetCredentials;
fn_get_device_token_t
                pfnGetDeviceToken;
fn_http_response_cb_t
                pfnHttpResponse;
fn_session_timeout_cb_t
                pfnSessionTimeout;
fn_threat_check_cb_t
                pfnDeviceSecurityCheck;
fn_threat_check_status_cb_t
                pfnDeviceThreatStatus;
fn_sdk_log_cb_t
                pfnPostSdkLog;
} core_callbacks_t;
```
-->

```java
public abstract class RDNA {
  //...
  public static interface RDNACallbacks {
    public int onInitializeCompleted(RDNAStatusInit status);
    public int onGetNotifications(RDNAStatusGetNotifications status);
    public int onUpdateNotification(RDNAStatusUpdateNotification status);
    public int onTerminate(RDNAStatusTerminate status);
    public int onPauseRuntime(RDNAStatusPause status);
    public int onResumeRuntime(RDNAStatusResume status);
    public int onConfigReceived(RDNAStatusGetConfig status);
    public int onCheckChallengeResponseStatus(RDNAStatusCheckChallengeResponse status);
    public int onGetAllChallengeStatus(RDNAStatusGetAllChallenges status);
    public int onUpdateChallengeStatus(RDNAStatusUpdateChallenges status);
    public int onGetPostLoginChallenges(RDNAStatusGetPostLoginChallenges status);
    public int onLogOff(RDNAStatusLogOff status);
    public int onGetRegistredDeviceDetails(RDNAStatusGetRegisteredDeviceDetails status);
    public int onUpdateDeviceDetails(RDNAStatusUpdateDeviceDetails status);
    public int onGetNotificationsHistory(RDNAStatusGetNotificationHistory status);
    public int onSessionTimeout(String status);
    public int onSdkLogPrintRequest(RDNALoggingLevel level, String logData);

    public RDNAIWACreds getCredentials(String domainUrl);
    public String getApplicationName();
    public String getApplicationVersion();
    public Context getDeviceContext();
    public String getDeviceToken();
}
  //..
}
```

```objective_c
@protocol RDNACallbacks

  - (int)onInitializeCompleted:(RDNAStatusInit *)status;
  - (CLLocationManager *)getLocationManager;
  - (NSString *)getApplicationVersion;
  - (NSString *)getApplicationName;
  - (int)onTerminate:(RDNAStatusTerminate *)status;
  - (int)onPauseRuntime:(RDNAStatusPauseRuntime *)status;
  - (int)onResumeRuntime:(RDNAStatusResumeRuntime *)status;
  - (int)onConfigReceived:(RDNAStatusGetConfig *)status;
  - (int)onCheckChallengeResponseStatus:(RDNAStatusCheckChallengeResponse *) status;
  - (int)onGetAllChallengeStatus:(RDNAStatusGetAllChallenges *) status;
  - (int)onUpdateChallengeStatus:(RDNAStatusUpdateChallenges *) status;
  - (int)onLogOff: (RDNAStatusLogOff *)status;
  - (RDNAIWACreds *)getCredentials:(NSString *)domainUrl;
  - (int)ShowLocationDailogue;
  - (int)onGetPostLoginChallenges:(RDNAStatusGetPostLoginChallenges *)status;
  - (int)onGetRegistredDeviceDetails:(RDNAStatusGetRegisteredDeviceDetails *)status;
  - (int)onUpdateDeviceDetails:(RDNAStatusUpdateDeviceDetails *)status;
  - (int)onGetNotifications:(RDNAStatusGetNotifications *)status;
  - (int)onUpdateNotification:(RDNAStatusUpdateNotification *)status;
  - (NSString*)getDeviceToken;
  - (int)onGetNotificationsHistory:(RDNAStatusGetNotificationHistory *)status;
  - (int)onSessionTimeout:(NSString*)status;
  - (int)onSecurityThreat:(NSString*)status;
  - (int)onSdkLogPrintRequest:(RDNALoggingLevel)level andlogData:(NSString*)logData;
@end
```

```cpp
class RDNACallbacks
{
public:
  virtual int onInitializeCompleted(RDNAStatusInit status) = 0;
  virtual int onTerminate(RDNAStatusTerminate status);
  virtual int onPauseRuntime(RDNAStatusPause status);
  virtual int onResumeRuntime(RDNAStatusResume status);
  virtual int onConfigReceived(RDNAStatusGetConfig status);
  virtual int onCheckChallengeResponseStatus(RDNAStatusCheckChallengeResponse status);
  virtual int onGetAllChallengeStatus(RDNAStatusGetAllChallenges status);
  virtual int onUpdateChallengeStatus(RDNAStatusUpdateChallenges status);
  virtual int onLogOff(RDNAStatusLogOff status);
  virtual int onGetPostLoginChallenges(RDNAStatusGetPostLoginChallenges status);
  virtual int onGetRegistredDeviceDetails(RDNAStatusGetRegisteredDeviceDetails status);
  virtual int onUpdateDeviceDetails(RDNAStatusUpdateDeviceDetails status);
  virtual int onGetNotifications(RDNAStatusGetNotifications status);
  virtual int onUpdateNotification(RDNAStatusUpdateNotification status);
  virtual void onSessionTimeout(void* pvAppCtx);
  virtual void onRdnaLogs(void* pvAppCtx, RDNALoggingLevel eLevel, std::string sLogData);

  virtual RDNAIWACreds getCredentials(std::string domainUrl);
  virtual std::string getApplicationName();
  virtual std::string getApplicationVersion();
  virtual std::string getDeviceToken();
};
```

Callback Routine | Description
---------------- | -----------
<b>Status Object and variants</b> | Invoked by the API runtime in order to update the API-client application of the progress of a previously invoked API routine, or state changes and exceptions encountered in general during the course of its execution.
<b>GetDeviceContext</b> | Invoked by the API runtime during initialization (session creation) on Android (Java) in order to retrieve the device context reference to be able to determine the fingerprint identity of the end-point device.<br><br>The API-client must return the Android <u>ApplicationContext</u> of the application from this method's implementation.<br><b><u>This callback routine is specific to Android platform</u></b>
<b>getLocationManager</b> | Invoked by the API runtime during initialization for the purpose of computing the location attributes of the device.<br><b><u>This callback routine is specific to iOS platform</u></b>
<b>getApplicationName</b> | Invoked by the API runtime when the runtime needs to retrieve the application name. The application name is used for blacklisting or whitelisting an application.
<b>getApplicationVersion</b> | This is the callback invoked when the runtime needs to retrieve the application version. The application version is used for blacklisting or whitelisting an application.
<b>getDeviceFingerprint</b> | This is the callback invoked by the core API runtime to retrieve device fingerprint identity information. The information is used for device fingerprinting.
<b>getCredentials</b> | This is the callback invoked by the DNA, when it needs the HTTP authentication credentials for accessing a webpage. The parameter domainURL is of the form <<u>HNIP</u>:<u>Port</u>>, where HNIP represent the Hostname or IP address where the webpage is hosted, and the Port represents to the port number to which the connection is being made. The callback implementation is expected to return an ```RDNAIWACreds``` object containing the relevant credentials.
<b>getDeviceToken</b> | Invoked by the API runtime during user session creation in order to retrieve the notification system specific application device token. The callback implementation is expected to return a unique device token of application which is registered with application notification servers

Apart from the above callback routines, specific events have been called out as onThisHappened() and onThatHappened() callbacks, in the wrapper APIs. This is to make it simpler and clearer for the API-client to react to these events.

## Proxy settings (structure)

This structure is supplied to the Initialize routine when the REL-ID Auth Gateway is accessible only from behind an HTTP proxy. For example, when using a REL-ID-integrated application from a device, when connected to a corporate intranet, where connectivity to internet is only via the corporate proxy.

Hence this structure is an optional input parameter to Initialize, and may not always require to be supplied. The API-client application requires to keep track of whether or not this needs to be supplied during initialization - for example by providing a 'connect profile settings' screen for the end-user.

At an abstract level, the pieces of information supplied by this data structure are:

<!--
```c
typedef struct {
  char* sProxyHNIP;
  int   nProxyPort;
  char* sUsername;
  char* sPassword;
  char** sProxyExceptionList;
} proxy_settings_t;
```
-->

```java
public abstract class RDNA {
  //...
  public static class RDNAProxySettings {
    public String proxyHNIP;
    public int proxyPort;
    public String username;
    public String password;
  }
  //...
}
```

```objective_c
@interface RDNAProxySettings : NSObject
  @property (nonatomic, copy) NSString *proxyHNIP;
  @property (nonatomic) uint16_t proxyPort;
  @property (nonatomic, copy) NSString *username;
  @property (nonatomic, copy) NSString *password;
@end
```

```cpp
typedef struct RDNAProxySettings_s {
  std::string    proxyHNIP;
  unsigned short proxyPort;
  std::string    username;
  std::string    password;
  vector<std::string> proxyExceptionList;
} RDNAProxySettings;
```

Field | Description
----- | -----------
<b>ProxyHNIP</b> | <b>H</b>ost<b>N</b>ame or <b>IP</b> address of the proxy server
<b>ProxyPort</b> | Port number of the proxy server
<b>ProxyUsername</b> | The username to use to authenticate with the proxy server. This is required only when the proxy server requires authentication.
<b>ProxyPassword</b> | The password to use with the username, to authenticate with the proxy server. This too is required only when the proxy server requires authentication.
<b>ProxyExceptionList</b> | The list speciifes to not use proxy server for addressess in the exception list.

## Log Levels (enum)

```cpp
typedef enum {
  RDNA_NO_LOGS = 0,
  RDNA_LOG_WARN,
  RDNA_LOG_NOTIFY,
  RDNA_LOG_NETWORK,
  RDNA_LOG_DNA,
  RDNA_LOG_DEBUG,
  RDNA_LOG_VERBOSE
} RDNALoggingLevel;
```

```objective_c
typedef NS_ENUM(NSInteger, RDNALoggingLevel) {
 RDNA_NO_LOGS = 0,
 RDNA_LOG_WARN,
 RDNA_LOG_NOTIFY,
 RDNA_LOG_NETWORK,
 RDNA_LOG_DNA,
 RDNA_LOG_DEBUG,
 RDNA_LOG_VERBOSE
};
```

```java
public static enum RDNALoggingLevel{
    RDNA_NO_LOGS(0),
    RDNA_LOG_WARN(1),
    RDNA_LOG_NOTIFY(2),
    RDNA_LOG_NETWORK(3),
    RDNA_LOG_DNA(4),
    RDNA_LOG_DEBUG(5),
    RDNA_LOG_VERBOSE(6);
}
```

This enum specifies the type of SDK logs that will be provided to the application.

Enumeration | Description
----------- | -----------
<b>RDNA_NO_LOGS</b> |  Logging will be off
<b>RDNA_LOG_WARN</b> | Used to log warning sort of messages
<b>RDNA_LOG_NOTIFY</b> | Conditions that are not error conditions, but that may require special handling.
<b>RDNA_LOG_NETWORK</b> | Socket level logs
<b>RDNA_LOG_DNA</b> | Logs from the DNA library
<b>RDNA_LOG_DEBUG</b> | Specifies Debug logs
<b>RDNA_LOG_VERBOSE</b> | Specifies more detailed logs than debug level

## SSL Certificates (structure)

This structure is supplied to the Initialize routine when the REL-ID Auth Gateway is accessible over SSL/TLS. It requires a certificate in a base64 encoded P12 format. The CA (certifying authority) provides certificates in P12 format. It is the responsibility of the APP developer to base64 encode this certificate and then pass it to the SSL certificate structure.

The SDK parse this SSL structure and sets up an internal SSL context which will be used further to perform SSL handshake for every communication made with REL-ID Gateway. For every new communication with the REL-ID Gateway, SSL handshake will be performed which is immediately followed by RMAK handshake.

This structure is an optional input parameter to Initialize, and may not always require to be supplied. If specified as NULL, no SSL handshake will be performed while communicating with the REL-ID Gateway.

At an abstract level, the pieces of information supplied by this data structure are:

<!--
```c
typedef struct
{
	char *p12Certificate;
	char *password;
} core_ssl_certificate;
```
-->

```java
public abstract class RDNA {
  //...
  public static class RDNASSLCerts {
    public String p12Certificate;
    public String password;
  }
  //...
}
```

```objective_c
@interface RDNASSLCertificate : NSObject
  @property (nonatomic,strong) NSString* p12Certificate;
  @property (nonatomic,strong) NSString* password;
@end
```

```cpp
typedef struct RDNASSLCerts_s {
  std::string    p12Certificate;
  std::string    password;
} RDNASSLCerts;
```

Field | Description
----- | -----------
<b>P12 Certificate</b> | A base64-encoded P12 Certificate issued by the CA.
<b>Password</b> | The password used while generating the P12 Certificate.

## Status update (structures)

This structure is supplied to the API-client supplied ```StatusUpdate``` callback routine when it is invoked from the API runtime. This structure covers all possible statuses that the API runtime would notify the API-client application about.

At an abstract level, the pieces of information supplied by this data structure are:

<!--
```c
typedef struct {
  union {
    struct {
      core_service_t** pServices;
      int              nServices;
    } initialize;
  } u;
} core_args_t;

typedef struct {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  e_core_method_t methodID;
  int  errCode;
  core_args_t* pArgs;
} core_status_t;
```
-->

```java
public abstract class RDNA {
  //..
  public static class RDNAStatusInit {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAService services[];
    public RDNAPort pxyDetails;
    public RDNAChallenge[] challenges;
  }

  public static class RDNAStatusTerminate {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
  }

  public static class RDNAStatusPause {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
  }

  public static class RDNAStatusResume {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAService services[];
    public RDNAPort pxyDetails;
    public RDNAChallenge[] challenges;
    public RDNAResponseStatus status;
  }

  public static class RDNAStatusGetConfig {
    public Object pvtRuntimeCtx;                         
    public Object pvtAppCtx;                             
    public int errCode;                                  
    public RDNA.RDNAMethodID methodID;                   
    public String responseData;
  }

  public static class RDNAStatusCheckChallengeResponse {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAResponseStatus status;
    public RDNAChallenge[] challenges;
    public RDNAService services[];
    public RDNAPort pxyDetails;
  }

  public static class RDNAStatusUpdateChallenges {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallenge[] challenges;
    public RDNAResponseStatus status;
  }

  public static class RDNAStatusGetAllChallenges {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallenge[] challenges;
    public RDNAResponseStatus status;
  }

  public static class RDNAStatusLogOff {
    public Object pvtRuntimeCtx;                        
    public Object pvtAppCtx;                            
    public int errCode;                                 
    public RDNA.RDNAMethodID methodID;                  
    public RDNA.RDNAService services[];                 
    public RDNA.RDNAPort pxyDetails;                    
    public RDNA.RDNAChallenge[] challenges;             
    public RDNA.RDNAResponseStatus status;
  }

  public static class RDNAStatusGetPostLoginChallenges{
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAResponseStatus status;
    public RDNAChallenge[] challenges;
  }

  public static class RDNAStatusGetRegisteredDeviceDetails {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNADeviceDetails[] devices;
    public RDNAResponseStatus status;
  }

  public static class RDNAStatusUpdateDeviceDetails {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAResponseStatus status;
  }

  public static class RDNAStatusGetNotifications {
    public Object pvtRuntimeCtx;                           
    public Object pvtAppCtx;                               
    public int errCode;                                    
    public RDNA.RDNAMethodID methodID;                     
    public RDNA.RDNAResponseStatus status;                 
    public int totalNotificationCount;                     
    public int startIndex;                                 
    public int fetchedNotificationCount;                   
    public RDNA.RDNANotification[] notifications;
  }

  public static class RDNAStatusUpdateNotification {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAResponseStatus status;
    public String notificationID;
  }

  public static class RDNAStatusGetNotificationHistory {
    public Object pvtRuntimeCtx;                                   
    public Object pvtAppCtx;                                       
    public int errCode;                                            
    public RDNAMethodID methodID;                                 
    public int totalNotificationCount;                            
    public RDNAResponseStatus status;                              
    RDNANotificationHistory[] notificationHistory;  
  }
  //..
}
```

```objective_c

@interface RDNAStatusInit : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusTerminate : NSObject
  @property (nonatomic) void* pvtRuntimeCtx;
  @property (nonatomic) void* pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
@end

@interface RDNAStatusPauseRuntime : NSObject
  @property (nonatomic) void* pvtRuntimeCtx;
  @property (nonatomic) void* pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
@end

@interface RDNAStatusResumeRuntime : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) NSArray *challenges;
  @property (nonatomic) RDNAResponseStatus *status;
@end

@interface RDNAStatusCheckChallengeResponse : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) RDNAResponseStatus *status;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusUpdateChallenges : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAResponseStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusGetAllChallenges : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAResponseStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusLogOff : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) RDNAResponseStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusGetRegisteredDeviceDetails : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errorCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) NSArray *devices;
  @property (nonatomic) RDNAResponseStatus *status;
@end

@interface RDNAStatusUpdateDeviceDetails : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errorCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAResponseStatus *status;
@end

@interface RDNAStatusGetPostLoginChallenges : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAResponseStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusGetNotifications : NSObject
   @property (nonatomic) void *pvtRuntimeCtx;
   @property (nonatomic) void *pvtAppCtx;
   @property (nonatomic) int  errCode;
   @property (nonatomic) int totalNotificationCount;
   @property (nonatomic) int startIndex;
   @property (nonatomic) int fetchedNotificationCount;
   @property (nonatomic) RDNAMethodID methodID;
   @property (nonatomic) RDNAResponseStatus *status;
   @property (nonatomic,strong) NSArray<RDNANotification *> *notifications;
@end

@interface RDNAStatusUpdateNotification : NSObject
   @property (nonatomic) void *pvtRuntimeCtx;
   @property (nonatomic) void *pvtAppCtx;
   @property (nonatomic) int  errCode;
   @property (nonatomic) NSString *notificationID;
   @property (nonatomic) RDNAMethodID methodID;
   @property (nonatomic) RDNAResponseStatus *status;
@end

@interface RDNAStatusGetNotificationHistory : NSObject
    @property (nonatomic) void *pvtRuntimeCtx;
    @property (nonatomic) void *pvtAppCtx;
    @property (nonatomic) int errCode;
    @property (nonatomic) RDNAMethodID methodID;
    @property (nonatomic) int totalNotificationCount;
    @property (nonatomic) RDNAResponseStatus *status;
    @property (nonatomic,strong) NSArray<RDNANotificationHistory *> *notificationHistory;
@end

@interface RDNAStatusGetConfig : NSObject
    @property (nonatomic) void *pvtRuntimeCtx;
    @property (nonatomic) void *pvtAppCtx;
    @property (nonatomic) int errCode;
    @property (nonatomic) RDNAMethodID methodID;
    @property (nonatomic) NSString *responseData;
@end
```

```cpp
typedef struct {
  void*        pvtRuntimeCtx;
  void*        pvtAppCtx;
  int          errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  vector<RDNAService> services;
  vector<RDNAChallenge> challenges;
} RDNAStatusInit;

typedef struct {
  void*        pvtRuntimeCtx;
  void*        pvtAppCtx;
  int          errCode;
  RDNAMethodID methodID;
} RDNAStatusTerminate;

typedef struct {
  void*        pvtRuntimeCtx;
  void*        pvtAppCtx;
  int          errCode;
  RDNAMethodID methodID;
} RDNAStatusPause;

typedef struct {
  void*        pvtRuntimeCtx;
  void*        pvtAppCtx;
  int          errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  vector<RDNAService> services;
  vector<RDNAChallenge> challenges;
} RDNAStatusResume;

typedef struct RDNAStatusCheckChallengeResponse_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  RDNAResponseStatus status;
  vector<RDNAService> services;
  vector<RDNAChallenge> challenges;
  RDNAStatusCheckChallengeResponse_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusCheckChallengeResponse;

typedef struct RDNAStatusUpdateChallenges_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAResponseStatus status;
  vector<RDNAChallenge> challenges;
  RDNAStatusUpdateChallenges_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusUpdateChallenges;

typedef struct RDNAStatusGetAllChallenges_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAResponseStatus status;
  vector<RDNAChallenge> challenges;
  RDNAStatusGetAllChallenges_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusGetAllChallenges;

typedef struct RDNAStatusLogOff_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  RDNAResponseStatus status;
  vector<RDNAService> services;
  vector<RDNAChallenge> challenges;
  RDNAStatusLogOff_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                         methodID(RDNA_METH_NONE)
  {}
} RDNAStatusLogOff;

typedef struct RDNAStatusGetRegisteredDeviceDetails_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  vector<RDNADeviceDetails> devices;
  RDNAStatusGetRegisteredDeviceDetails_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                         methodID(RDNA_METH_NONE)
  {}
} RDNAStatusGetRegisteredDeviceDetails;

typedef struct RDNAStatusUpdateDeviceDetails_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAResponseStatus updateStatus;
  RDNAStatusUpdateDeviceDetails_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                         methodID(RDNA_METH_NONE)
  {}
} RDNAStatusUpdateDeviceDetails;

typedef struct RDNAStatusGetPostLoginChallenges_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAResponseStatus status;
  vector<RDNAChallenge> challenges;
  RDNAStatusGetPostLoginChallenges_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                       methodID(RDNA_METH_NONE)
  {}
} RDNAStatusGetPostLoginChallenges;

typedef struct RDNAStatusGetNotifications_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  int totalNotificationCount;
  int startIndex;
  int fetchedNotificationCount;
  RDNAMethodID methodID;
  RDNAResponseStatus status;
  vector<RDNANotification> notifications;
  RDNAStatusGetNotifications_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusGetNotifications;

struct RDNAStatusUpdateNotification {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  string notificationID;
  RDNAMethodID methodID;
  RDNAResponseStatus status;
  RDNAStatusUpdateNotification () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
};

typedef struct RDNAStatusGetNotificationHistory_s {
  void* pvtRuntimeCtx;                            /* Context of API runtime                                */
  void* pvtAppCtx;                                /* Context of API-client                                 */
  int  errCode;                                   /* Error code return                                     */
  int totalNotificationCount;                     /* Total notifications available in server side for user */
  RDNAMethodID methodID;                          /* update for method                                     */
  RDNAResponseStatus status;                      /* Response status information                           */
  vector<RDNANotificationHistory> notifications;  /* Notification array                                    */
}RDNAStatusGetNotificationHistory;

```

Field | Description
----- | -----------
<b>RDNA (API&nbsp;runtime) Context</b> | ```pvtRuntimeCtx```<br>A reference to the RDNA context returned upon successful ```Initialize``` routine invocation. Note that there can technically be multiple such contexts active in the same API-client application - it depends on the application and its purpose.
<b>API-Client (Application) Context</b> | ```pvtAppCtx```<br>An opaque reference to the API-client supplied context. This is supplied by the API-client to the ```Initialize``` routine, and is associated with the REL-ID DNA context throughout its lifetime. Note that this context is never read/interpreted or modified by the API runtime.
<b>Method&nbsp;ID</b> | ```methodID```<br>An identifier that specifies which method was invoked by the API-client application.
<b>Error&nbsp;Code</b> | ```errCode```<br>An identifier that specifies the nature of the error that is being reported in the status update.
<b>Status&nbsp;Arguments</b> | <li><b>In the Core API (ANSI C)</b>, this is a polymorphic reference to status information - the actual reference to use depends on the method and error identifiers.<li><b>In the Wrapper APIs (Java, Obj-C, C++)<b>, each status structure is separate <i>per event</i>, and hence is one or more members specific to that event's structure <b>Array&nbsp;of&nbsp;Challenges</b> | ```challenges```<br><li>For the RDNAStatusInit status object, this is the initial set of challenges. The API client needs to respond to these challenges, which initiates the user authentication sequence. If the API-client does not wish to perform user authentication, this member can be ignored.<li>For the rest of the status objects, this is the array of challenges thrown by the server to the API-client as part of the user authentication flow or for allowing the API-client to update the security challenges and their responses.
<b>Tunnel Proxy details</b> | ```pxyDetails``` <br> The tunnel proxy service listening port information and other details.
<b>Array of Services </b> | ```services``` <br> Array of services, it will include the list of services which are tunneled.
<b>Array of devices </b> | ```devices``` <br> All the registered devices list, for the specific user.
<b>Array of notifications </b> | ```notifications``` <br> All the notifications received from the server
<b>Number of notifications </b> | ```fetchedNotificationCount``` <br> The number of notification received currently
<b>Start Index </b> | ```startIndex``` <br> The starting index of the current notifications received
<b>Total Notification Count </b> | ```totalNotificationCount``` <br> Total active notifications available at server for the user.
<b>Notification ID </b> | ```notificationID``` <br> The notification Id which has been updated at server.

The wrapper APIs written in high level languages provide similar information of status update in more specific callbacks and structures such as RDNAStatusInit, RDNAStatusPause, etc. This is to make it simpler and clearer for the API-client to react to these events.


## HTTP Authentication related structures, interfaces, enumerations and callbacks

For supporting HTTP based authentication, we provide the following

```java
public abstract class RDNA {

  public static class RDNAIWACreds {
    public String userName;
    public String userPassword;
    public RDNAIWAAuthStatus status;

    public RDNAIWACreds() {}

	public RDNAIWACreds(String userName,String userPassword,RDNAIWAAuthStatus status) {
      this.userName = userName;
      this.userPassword = userPassword;
      this.status = status;
	}
  }

  public enum RDNAIWAAuthStatus {
    AUTH_SUCCESS(0),
    AUTH_CANCELLED(1),
    AUTH_DEFERRED(2);

    public int intVal;

    private RDNAIWAAuthStatus(int val) {
      this.intVal = val;
	}
}
```

```objective_c
@interface RDAIWACreds : NSObject
  @property (nonatomic, strong) NSString *userName;
  @property (nonatomic, strong) NSString *password;
  @property (assign) RDNAIWAAuthStatus authStatus;
@end

typedef NS_ENUM(NSInteger, RDNAIWAAuthStatus) {
  RDNA_IWA_AUTH_SUCCESS   = 0,
  RDNA_IWA_AUTH_CANCELLED = 1,
  RDNA_IWA_AUTH_DEFERRED  = 2
};
```

```cpp
typedef struct RDNAIWACreds_s {
  std::string userName;                    /* userName for authentication */
  std::string password;                    /* password for authentication */
  RDNAIWAAuthStatus authStatus;            /* status of authentication    */
  RDNAIWACreds_s() : userName(""),password(""), authStatus(RDNA_IWA_AUTH_SUCCESS)
  {}
} RDNAIWACreds;

typedef enum{
  RDNA_IWA_AUTH_SUCCESS   = 0,
  RDNA_IWA_AUTH_CANCELLED = 1,
  RDNA_IWA_AUTH_DEFERRED  = 2
} RDNAIWAAuthStatus;
```

Member | Description
------ | -----------
userName | This is the userName to be used when attempting to perform HTTP authentication
password | This is the password to be used when attempting to perform HTTP authentication
authStatus | This represents the status of the operation to fetch credentials for performing HTTP authentication


Enum | Value | Description
---- | ----- | -----------
RDNA_IWA_AUTH_SUCCESS | 0 | The API client was able to successfully fetch the appropriate credentials for performing HTTP authentication
RDNA_IWA_AUTH_CANCELLED | 1 | The API client has cancelled the request for fetching credentials. This will result in failure of the HTTP request.
RDNA_IWA_AUTH_DEFERRED | 2 | This represents the state where the API client has deferred the task of fetching the credentials. The API client would then at a later point of time provide the credentials

## Error codes (enum)

<!--
```c
typedef enum {
  CORE_ERR_NONE = 0,                         
  CORE_ERR_NOT_INITIALIZED,                  
  CORE_ERR_GENERIC_ERROR,                    
  CORE_ERR_INVALID_VERSION,                  
  CORE_ERR_INVALID_ARGS,                     
  CORE_ERR_SESSION_EXPIRED,                  
  CORE_ERR_PARENT_PROXY_CONNECT_FAILED,      
  CORE_ERR_NULL_CALLBACKS,                   
  CORE_ERR_INVALID_HOST,                     
  CORE_ERR_INVALID_PORTNUM,                  
  CORE_ERR_INVALID_AGENT_INFO,               
  CORE_ERR_FAILED_TO_CONNECT_TO_SERVER,      
  CORE_ERR_INVALID_SAVED_CONTEXT,            
  CORE_ERR_INVALID_HTTP_REQUEST,             
  CORE_ERR_INVALID_HTTP_RESPONSE,            
  CORE_ERR_INVALID_CIPHERSPECS,              
  CORE_ERR_SERVICE_NOT_SUPPORTED,            
  CORE_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE,
  CORE_ERR_FAILED_TO_GET_STREAM_TYPE,        
  CORE_ERR_FAILED_TO_WRITE_INTO_STREAM,      
  CORE_ERR_FAILED_TO_END_STREAM,             
  CORE_ERR_FAILED_TO_DESTROY_STREAM,         
  CORE_ERR_FAILED_TO_INITIALIZE,             
  CORE_ERR_FAILED_TO_PAUSERUNTIME,           
  CORE_ERR_FAILED_TO_RESUMERUNTIME,          
  CORE_ERR_FAILED_TO_TERMINATE,              
  CORE_ERR_FAILED_TO_GET_CIPHERSALT,         
  CORE_ERR_FAILED_TO_GET_CIPHERSPECS,        
  CORE_ERR_FAILED_TO_GET_AGENT_ID,           
  CORE_ERR_FAILED_TO_GET_SESSION_ID,         
  CORE_ERR_FAILED_TO_GET_DEVICE_ID,          
  CORE_ERR_FAILED_TO_GET_SERVICE,            
  CORE_ERR_FAILED_TO_START_SERVICE,          
  CORE_ERR_FAILED_TO_STOP_SERVICE,           
  CORE_ERR_FAILED_TO_ENCRYPT_DATA_PACKET,    
  CORE_ERR_FAILED_TO_DECRYPT_DATA_PACKET,    
  CORE_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST,   
  CORE_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE,  
  CORE_ERR_FAILED_TO_CREATE_PRIVACY_STREAM,  
  CORE_ERR_FAILED_TO_CHECK_CHALLENGE,        
  CORE_ERR_FAILED_TO_UPDATE_CHALLENGE,       
  CORE_ERR_FAILED_TO_GET_CONFIG,             
  CORE_ERR_FAILED_TO_GET_ALL_CHALLENGES,     
  CORE_ERR_FAILED_TO_LOGOFF,                 
  CORE_ERR_FAILED_TO_RESET_CHALLENGE,        
  CORE_ERR_FAILED_TO_DO_FORGOT_PASSWORD,     
  CORE_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES,   
  CORE_ERR_FAILED_TO_GET_REGISTERD_DEVICE_DETAILS,
  CORE_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS,       
  CORE_ERR_FAILED_TO_GET_NOTIFICATIONS,           
  CORE_ERR_FAILED_TO_UPDATE_NOTIFICATION,         
  CORE_ERR_FAILED_TO_OPEN_HTTP_CONNECTION,        
  CORE_ERR_SSL_INIT_FAILED,
  CORE_ERR_SSL_ACTIVITY_FAILED,
  CORE_ERR_DNS_FAILED,
  CORE_ERR_NET_DOWN,
  CORE_ERR_SOCK_TIMEDOUT,
  CORE_ERR_DNA_INTERNAL = 57
} e_core_error_t;
```
-->

```java
public abstract class RDNA {
  //...
  public enum RDNAErrorID {
    RDNA_ERR_NONE(0),                              
    RDNA_ERR_NOT_INITIALIZED(1),                   
    RDNA_ERR_GENERIC_ERROR(2),                     
    RDNA_ERR_INVALID_VERSION(3),                   
    RDNA_ERR_INVALID_ARGS(4),                      
    RDNA_ERR_SESSION_EXPIRED(5),                   
    RDNA_ERR_PARENT_PROXY_CONNECT_FAILED(6),       
    RDNA_ERR_NULL_CALLBACKS(7),                    
    RDNA_ERR_INVALID_HOST(8),                      
    RDNA_ERR_INVALID_PORTNUM(9),                   
    RDNA_ERR_INVALID_AGENT_INFO(10),                    
    RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER(11),           
    RDNA_ERR_INVALID_SAVED_CONTEXT(12),                 
    RDNA_ERR_INVALID_HTTP_REQUEST(13),                  
    RDNA_ERR_INVALID_HTTP_RESPONSE(14),                 
    RDNA_ERR_INVALID_CIPHERSPECS(15),                   
    RDNA_ERR_SERVICE_NOT_SUPPORTED(16),                 
    RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE(17),     
    RDNA_ERR_FAILED_TO_GET_STREAM_TYPE(18),             
    RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM(19),           
    RDNA_ERR_FAILED_TO_END_STREAM(20),                  
    RDNA_ERR_FAILED_TO_DESTROY_STREAM(21),              
    RDNA_ERR_FAILED_TO_INITIALIZE(22),                  
    RDNA_ERR_FAILED_TO_PAUSERUNTIME(23),                
    RDNA_ERR_FAILED_TO_RESUMERUNTIME(24),               
    RDNA_ERR_FAILED_TO_TERMINATE(25),                   
    RDNA_ERR_FAILED_TO_GET_CIPHERSALT(26),              
    RDNA_ERR_FAILED_TO_GET_CIPHERSPECS(27),             
    RDNA_ERR_FAILED_TO_GET_AGENT_ID(28),                
    RDNA_ERR_FAILED_TO_GET_SESSION_ID(29),              
    RDNA_ERR_FAILED_TO_GET_DEVICE_ID(30),               
    RDNA_ERR_FAILED_TO_GET_SERVICE(31),                 
    RDNA_ERR_FAILED_TO_START_SERVICE(32),               
    RDNA_ERR_FAILED_TO_STOP_SERVICE(33),                
    RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET(34),         
    RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET(35),         
    RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST(36),        
    RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE(37),       
    RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM(38),       
    RDNA_ERR_FAILED_TO_CHECK_CHALLENGE(39),             
    RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE(40),            
    RDNA_ERR_FAILED_TO_GET_CONFIG(41),                  
    RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES(42),          
    RDNA_ERR_FAILED_TO_LOGOFF(43),                      
    RDNA_ERR_FAILED_TO_RESET_CHALLENGE(44),             
    RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD(45),          
    RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES(46),   
    RDNA_ERR_FAILED_TO_GET_REGISTERD_DEVICE_DETAILS(47),
    RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS(48),       
    RDNA_ERR_FAILED_TO_GET_NOTIFICATIONS(49),           
    RDNA_ERR_FAILED_TO_UPDATE_NOTIFICATION(50),         
    RDNA_ERR_FAILED_TO_OPEN_HTTP_CONNECTION(51),        
    RDNA_ERR_SSL_INIT_FAILED(52),                       
    RDNA_ERR_SSL_ACTIVITY_FAILED(53),                   
    RDNA_ERR_DNS_FAILED(54),                            
    RDNA_ERR_NET_DOWN(55),                              
    RDNA_ERR_SOCK_TIMEDOUT(56),                         
    RDNA_ERR_DNA_INTERNAL(57),                          
    RDNA_ERR_FAILED_TO_PARSE_DEVICES(58),               
    RDNA_ERR_INVALID_CHALLENGE_CONFIG(59),              
    RDNA_ERR_INVALID_HTTP_API_REQ_URL(60),              
    RDNA_ERR_NO_MEMORY(61),
    RDNA_ERR_INVALID_CONTEXT(62),
    RDNA_ERR_CIPHERTEXT_LENGTH_INVALID(63),
    RDNA_ERR_CIPHERTEXT_EMPTY(64),
    RDNA_ERR_PLAINTEXT_EMPTY(65),
    RDNA_ERR_PLAINTEXT_LENGTH_INVALID(66),
    RDNA_ERR_USERID_EMPTY(67),
    RDNA_ERR_CHALLENGE_EMPTY(68),
    RDNA_ERR_FAILED_TO_SERIALIZE_JSON(69),
    RDNA_ERR_USECASE_EMPTY(70),
    RDNA_ERR_INVALID_SERVICE_NAME(71),
    RDNA_ERR_DEVICE_DETAILS_EMPTY(72);
  }
  //..
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAErrorID) {
     RDNA_ERR_NONE = 0,                    
     RDNA_ERR_NOT_INITIALIZED,                      
     RDNA_ERR_GENERIC_ERROR,                        
     RDNA_ERR_INVALID_VERSION,                      
     RDNA_ERR_INVALID_ARGS,                         
     RDNA_ERR_SESSION_EXPIRED,                      
     RDNA_ERR_PARENT_PROXY_CONNECT_FAILED,          
     RDNA_ERR_NULL_CALLBACKS,                       
     RDNA_ERR_INVALID_HOST,                         
     RDNA_ERR_INVALID_PORTNUM,                      
     RDNA_ERR_INVALID_AGENT_INFO,                   
     RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER,          
     RDNA_ERR_INVALID_SAVED_CONTEXT,                
     RDNA_ERR_INVALID_HTTP_REQUEST,                 
     RDNA_ERR_INVALID_HTTP_RESPONSE,                
     RDNA_ERR_INVALID_CIPHERSPECS,                  
     RDNA_ERR_SERVICE_NOT_SUPPORTED,                
     RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE,    
     RDNA_ERR_FAILED_TO_GET_STREAM_TYPE,            
     RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM,          
     RDNA_ERR_FAILED_TO_END_STREAM,                 
     RDNA_ERR_FAILED_TO_DESTROY_STREAM,             
     RDNA_ERR_FAILED_TO_INITIALIZE,                 
     RDNA_ERR_FAILED_TO_PAUSERUNTIME,               
     RDNA_ERR_FAILED_TO_RESUMERUNTIME,              
     RDNA_ERR_FAILED_TO_TERMINATE,                  
     RDNA_ERR_FAILED_TO_GET_CIPHERSALT,             
     RDNA_ERR_FAILED_TO_GET_CIPHERSPECS,            
     RDNA_ERR_FAILED_TO_GET_AGENT_ID,               
     RDNA_ERR_FAILED_TO_GET_SESSION_ID,             
     RDNA_ERR_FAILED_TO_GET_DEVICE_ID,              
     RDNA_ERR_FAILED_TO_GET_SERVICE,                
     RDNA_ERR_FAILED_TO_START_SERVICE,              
     RDNA_ERR_FAILED_TO_STOP_SERVICE,               
     RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET,        
     RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET,        
     RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST,       
     RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE,      
     RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM,      
     RDNA_ERR_FAILED_TO_CHECK_CHALLENGE,            
     RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE,           
     RDNA_ERR_FAILED_TO_GET_CONFIG,                 
     RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES,         
     RDNA_ERR_FAILED_TO_LOGOFF,                     
     RDNA_ERR_FAILED_TO_RESET_CHALLENGE,            
     RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD,         
     RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES,  
     RDNA_ERR_FAILED_TO_GET_REGISTERD_DEVICE_DETAILS
     RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS,      
     RDNA_ERR_FAILED_TO_GET_NOTIFICATIONS,          
     RDNA_ERR_FAILED_TO_UPDATE_NOTIFICATION,        
     RDNA_ERR_FAILED_TO_OPEN_HTTP_CONNECTION,       
     RDNA_ERR_SSL_INIT_FAILED,                      
     RDNA_ERR_SSL_ACTIVITY_FAILED,                  
     RDNA_ERR_DNS_FAILED,                           
     RDNA_ERR_NET_DOWN,                             
     RDNA_ERR_SOCK_TIMEDOUT,                        
     RDNA_ERR_DNA_INTERNAL,                         
     RDNA_ERR_FAILED_TO_PARSE_DEVICES,              
     RDNA_ERR_INVALID_CHALLENGE_CONFIG,             
     RDNA_ERR_INVALID_HTTP_API_REQ_URL,             
     RDNA_ERR_NO_MEMORY,
     RDNA_ERR_INVALID_CONTEXT,
     RDNA_ERR_CIPHERTEXT_LENGTH_INVALID,
     RDNA_ERR_CIPHERTEXT_EMPTY,
     RDNA_ERR_PLAINTEXT_EMPTY,
     RDNA_ERR_PLAINTEXT_LENGTH_INVALID,
     RDNA_ERR_USERID_EMPTY,
     RDNA_ERR_CHALLENGE_EMPTY,
     RDNA_ERR_FAILED_TO_SERIALIZE_JSON,
     RDNA_ERR_USECASE_EMPTY,
     RDNA_ERR_INVALID_SERVICE_NAME,
};
```

```cpp
typedef enum {
    RDNA_ERR_NONE = 0,
    RDNA_ERR_NOT_INITIALIZED,
    RDNA_ERR_GENERIC_ERROR,
    RDNA_ERR_INVALID_VERSION,
    RDNA_ERR_INVALID_ARGS,
    RDNA_ERR_SESSION_EXPIRED,
    RDNA_ERR_PARENT_PROXY_CONNECT_FAILED,
    RDNA_ERR_NULL_CALLBACKS,
    RDNA_ERR_INVALID_HOST,
    RDNA_ERR_INVALID_PORTNUM,
    RDNA_ERR_INVALID_AGENT_INFO,
    RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER,
    RDNA_ERR_INVALID_SAVED_CONTEXT,
    RDNA_ERR_INVALID_HTTP_REQUEST,
    RDNA_ERR_INVALID_HTTP_RESPONSE,
    RDNA_ERR_INVALID_CIPHERSPECS,
    RDNA_ERR_SERVICE_NOT_SUPPORTED,
    RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE,
    RDNA_ERR_FAILED_TO_GET_STREAM_TYPE,
    RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM,
    RDNA_ERR_FAILED_TO_END_STREAM,
    RDNA_ERR_FAILED_TO_DESTROY_STREAM,
    RDNA_ERR_FAILED_TO_INITIALIZE,
    RDNA_ERR_FAILED_TO_PAUSERUNTIME,
    RDNA_ERR_FAILED_TO_RESUMERUNTIME,
    RDNA_ERR_FAILED_TO_TERMINATE,
    RDNA_ERR_FAILED_TO_GET_CIPHERSALT,
    RDNA_ERR_FAILED_TO_GET_CIPHERSPECS,
    RDNA_ERR_FAILED_TO_GET_AGENT_ID,
    RDNA_ERR_FAILED_TO_GET_SESSION_ID,
    RDNA_ERR_FAILED_TO_GET_DEVICE_ID,
    RDNA_ERR_FAILED_TO_GET_SERVICE,
    RDNA_ERR_FAILED_TO_START_SERVICE,
    RDNA_ERR_FAILED_TO_STOP_SERVICE,
    RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET,
    RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET,
    RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST,
    RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE,
    RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM,
    RDNA_ERR_FAILED_TO_CHECK_CHALLENGE,
    RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE,
    RDNA_ERR_FAILED_TO_GET_CONFIG,
    RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES,
    RDNA_ERR_FAILED_TO_LOGOFF,
    RDNA_ERR_FAILED_TO_RESET_CHALLENGE,
    RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD,
    RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES,
    RDNA_ERR_FAILED_TO_GET_REGISTERD_DEVICE_DETAILS,
    RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS,
    RDNA_ERR_FAILED_TO_GET_NOTIFICATIONS,
    RDNA_ERR_FAILED_TO_UPDATE_NOTIFICATION,
    RDNA_ERR_FAILED_TO_OPEN_HTTP_CONNECTION,
    RDNA_ERR_SSL_INIT_FAILED,
    RDNA_ERR_SSL_ACTIVITY_FAILED,
    RDNA_ERR_DNS_FAILED,
    RDNA_ERR_NET_DOWN,
    RDNA_ERR_SOCK_TIMEDOUT,
    RDNA_ERR_DNA_INTERNAL,
    RDNA_ERR_FAILED_TO_PARSE_DEVICES,
    RDNA_ERR_INVALID_CHALLENGE_CONFIG,
    RDNA_ERR_INVALID_HTTP_API_REQ_URL,
    RDNA_ERR_NO_MEMORY,
    RDNA_ERR_INVALID_CONTEXT,
    RDNA_ERR_CIPHERTEXT_LENGTH_INVALID,
    RDNA_ERR_CIPHERTEXT_EMPTY,
    RDNA_ERR_PLAINTEXT_EMPTY,
    RDNA_ERR_PLAINTEXT_LENGTH_INVALID,
    RDNA_ERR_USERID_EMPTY,
    RDNA_ERR_CHALLENGE_EMPTY,
    RDNA_ERR_FAILED_TO_SERIALIZE_JSON,
    RDNA_ERR_USECASE_EMPTY
} RDNAErrorID;
```

Error ID | Value | Meaning
-------- | ----- | -------
RDNA_ERR_NONE | 0  | The operation is successful and no error has occured
RDNA_ERR_NOT_INITIALIZED | 1 | The API Runtime is not initialized
RDNA_ERR_GENERIC_ERROR | 2 | Generic error has occured
RDNA_ERR_INVALID_VERSION | 3 | The SDK Version is invalid or unsupported
RDNA_ERR_INVALID_ARGS | 4 | The argument(s) passed to the API is invalid
RDNA_ERR_SESSION_EXPIRED | 5 | The argument(s) passed to the API is invalid
RDNA_ERR_PARENT_PROXY_CONNECT_FAILED  | 6 | Failed to connect to REL-ID Gateway Server via proxy.
RDNA_ERR_NULL_CALLBACKS | 7 | The callback/ptr passed in is null
RDNA_ERR_INVALID_HOST | 8 | The hostname/IP is null or empty
RDNA_ERR_INVALID_PORTNUM | 9 | The port number is invalid
RDNA_ERR_INVALID_AGENT_INFO | 10 | The agent info is invalid (check the agent info blob received by Admin)
RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER | 11 | Failed to connect to REL-ID Gateway Server
RDNA_ERR_INVALID_SAVED_CONTEXT | 12 | The saved context passed to Resume is invalid
RDNA_ERR_INVALID_HTTP_REQUEST | 13 | The Http Request passed to Encrypt Http API is invalid
RDNA_ERR_INVALID_HTTP_RESPONSE | 14 | The Http Request passed to Decrypt Http API is invalid
RDNA_ERR_INVALID_CIPHERSPECS | 15 | The cipher spec passed in is invalid
RDNA_ERR_SERVICE_NOT_SUPPORTED | 16 | The service provided is not supported
RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE | 17 | Failed to get stream privacy scope
RDNA_ERR_FAILED_TO_GET_STREAM_TYPE | 18 | Failed to get stream type
RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM | 19 | Failed to write into privacy stream
RDNA_ERR_FAILED_TO_END_STREAM | 20 | Failed to end privacy stream
RDNA_ERR_FAILED_TO_DESTROY_STREAM | 21 | Failed to destroy privacy stream
RDNA_ERR_FAILED_TO_INITIALIZE | 22 | Failed to initialize
RDNA_ERR_FAILED_TO_PAUSERUNTIME | 23 | Failed to pause runtime
RDNA_ERR_FAILED_TO_RESUMERUNTIME | 24 | Failed to resume runtime
RDNA_ERR_FAILED_TO_TERMINATE | 25 | Failed to terminate
RDNA_ERR_FAILED_TO_GET_CIPHERSALT | 26 | Failed to get cipher salt
RDNA_ERR_FAILED_TO_GET_CIPHERSPECS | 27 | Failed to get cipherspecs
RDNA_ERR_FAILED_TO_GET_AGENT_ID | 28 | Failed to get agent id
RDNA_ERR_FAILED_TO_GET_SESSION_ID | 29 | Failed to get session id
RDNA_ERR_FAILED_TO_GET_DEVICE_ID | 30 | Failed to get device id
RDNA_ERR_FAILED_TO_GET_SERVICE | 31 | Failed to get service
RDNA_ERR_FAILED_TO_START_SERVICE | 32 | Failed to start service
RDNA_ERR_FAILED_TO_STOP_SERVICE | 33 | Failed to stop service
RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET | 34 | Failed to encrypt data packet
RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET | 35 | Failed to decrypt data packet
RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST | 36 | Failed to encrypt HTTP request
RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE | 37 | Failed to decrypt HTTP response
RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM | 38 | Failed to create privacy stream
RDNA_ERR_FAILED_TO_CHECK_CHALLENGE | 39 | Failed to check challenge response
RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE | 40 | Failed to update challenge
RDNA_ERR_FAILED_TO_GET_CONFIG | 41 | Failed to retrieve configuration
RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES | 42 | Failed to retrieve list of all challenges
RDNA_ERR_FAILED_TO_LOGOFF | 43 | Failed to log off the user
RDNA_ERR_FAILED_TO_RESET_CHALLENGE | 44 | Failed to reset challenge
RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD | 45 | Failed to reset password via forgot password API
RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES | 46 | Error while attempting to fetch post-login challenges
RDNA_ERR_FAILED_TO_GET_REGISTERED_DEVICE_DETAILS | 47 | Error while attempting to get details of the registered devices of the user
RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS | 48 | Failed to update device details of the user
RDNA_ERR_FAILED_TO_GET_NOTIFICATIONS | 49 | Failed to get the notifications from server
RDNA_ERR_FAILED_TO_UPDATE_NOTIFICATION | 50 | Failed to update the notification
RDNA_ERR_FAILED_TO_OPEN_HTTP_CONNECTION | 51 | Failed to open HTTP api tunnel connection
RDNA_ERR_SSL_INIT_FAILED | 52 | SSL initialization failed
RDNA_ERR_SSL_ACTIVITY_FAILED | 53 | Error occurs while performing SSL related network operations
RDNA_ERR_DNS_FAILED | 54 | Domain name resolution failed
RDNA_ERR_NET_DOWN | 55 | Network is down
RDNA_ERR_SOCK_TIMEDOUT | 56 | Connection timed out.
RDNA_ERR_DNA_INTERNAL | 57 | Generic DNA (networking library) error
RDNA_ERR_FAILED_TO_PARSE_DEVICES | 58 | Failure in parsing device details
RDNA_ERR_INVALID_CHALLENGE_CONFIG | 59 | Misconfigured claange received
RDNA_ERR_INVALID_HTTP_API_REQ_URL | 60 | Invalid URL was specified in the HTTP appi tunnel connection
RDNA_ERR_NO_MEMORY| 61 | Device is running out of space
RDNA_ERR_INVALID_CONTEXT| 62 | The context passed to the API is invalid
RDNA_ERR_CIPHERTEXT_EMPTY | 63 | The cipher text passed to Decrypt API is empty
RDNA_ERR_CIPHERTEXT_LENGTH_INVALID | 64 | The cipher text length passed to Decrypt API is invalid
RDNA_ERR_PLAINTEXT_EMPTY | 65 | The plain text passed to Encrypt API is empty
RDNA_ERR_PLAINTEXT_LENGTH_INVALID | 66 | The plain text length passed to Encrypt API is invalid
RDNA_ERR_USERID_EMPTY | 67 | Userid field is empty
RDNA_ERR_CHALLENGE_EMPTY | 68 | Challenge field is empty
RDNA_ERR_FAILED_TO_SERIALIZE_JSON | 69 | Failed to serialize to internal representation
RDNA_ERR_USECASE_EMPTY | 70 | The input parameter to GetConfig API cannot be EMPTY or NULL
RDNA_ERR_INVALID_SERVICE_NAME | 71 | Returned if service name is not valid or null (Java SDK)
RDNA_ERR_DEVICE_DETAILS_EMPTY | 72 | Returned if passed device details is empty or null (Java SDK)

## Method identifiers (enum)

These identifiers are used to identify the routine when the ```StatusUpdate``` callback routine is invoked.

<!--
```c
typedef enum {
  CORE_METH_NONE = 0,
  CORE_METH_INITIALIZE,
  CORE_METH_TERMINATE,
  CORE_METH_RESUME,
  CORE_METH_PAUSE,
  CORE_METH_GET_CONFIG,
  CORE_METH_CHECK_CHALLENGE,
  CORE_METH_UPDATE_CHALLENGE,
  CORE_METH_GET_ALL_CHALLENGES,
  CORE_METH_LOGOFF,
  CORE_METH_GET_POST_LOGIN_CHALLENGES,
  CORE_METH_GET_DEVICE_DETAILS,
  CORE_METH_UPDATE_DEVICE_DETAILS,
  CORE_METH_GET_NOTIFICATIONS,
  CORE_METH_UPDATE_NOTIFICATION,
} e_core_method_t;
```
-->

```java
public abstract class RDNA {
  //..
  public enum RDNAMethodID {
    RDNA_METH_NONE(0),                            
    RDNA_METH_INITIALIZE(1),                      
    RDNA_METH_TERMINATE(2),                       
    RDNA_METH_RESUME(3),                          
    RDNA_METH_PAUSE(4),                           
    RDNA_METH_GET_CONFIG(5),                      
    RDNA_METH_CHECK_CHALLENGE(6),                 
    RDNA_METH_UPDATE_CHALLENGE(7),                
    RDNA_METH_GET_ALL_CHALLENGES(8),              
    RDNA_METH_LOGOFF(9),                          
    RDNA_METH_GET_POST_LOGIN_CHALLENGES(10),      
    RDNA_METH_GET_DEVICE_DETAILS(11),             
    RDNA_METH_UPDATE_DEVICE_DETAILS(12),          
    RDNA_METH_GET_NOTIFICATIONS(13),              
    RDNA_METH_UPDATE_NOTIFICATION(14),            
    RDNA_METH_GET_NOTIFICATION_HISTORY(15)
	RDNA_METH_OPEN_HTTP_CONNECTION(16);
  }
  //..
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAMethodID) {
   RDNA_METH_NONE = 0,                      
   RDNA_METH_INITIALIZE,                    
   RDNA_METH_TERMINATE,                     
   RDNA_METH_RESUME,                        
   RDNA_METH_PAUSE,                         
   RDNA_METH_GET_CONFIG,                    
   RDNA_METH_CHECK_CHALLENGE,               
   RDNA_METH_UPDATE_CHALLENGE,              
   RDNA_METH_GET_ALL_CHALLENGES,            
   RDNA_METH_LOGOFF,                        
   RDNA_METH_GET_POST_LOGIN_CHALLENGES,     
   RDNA_METH_GET_DEVICE_DETAILS,            
   RDNA_METH_UPDATE_DEVICE_DETAILS,         
   RDNA_METH_GET_NOTIFICATIONS,             
   RDNA_METH_UPDATE_NOTIFICATION,           
   RDNA_METH_GET_NOTIFICATION_HISTORY,      
   RDNA_METH_OPEN_HTTP_CONNECTION,          
};
```

```cpp
typedef enum {
  RDNA_METH_NONE = 0,
  RDNA_METH_INITIALIZE,
  RDNA_METH_TERMINATE,
  RDNA_METH_RESUME,
  RDNA_METH_PAUSE,
  RDNA_METH_GET_CONFIG,
  RDNA_METH_CHECK_CHALLENGE,
  RDNA_METH_UPDATE_CHALLENGE,
  RDNA_METH_GET_ALL_CHALLENGES,
  RDNA_METH_LOGOFF,
  RDNA_METH_GET_POST_LOGIN_CHALLENGES,
  RDNA_METH_GET_DEVICE_DETAILS,
  RDNA_METH_UPDATE_DEVICE_DETAILS,
  RDNA_METH_GET_NOTIFICATIONS,
  RDNA_METH_UPDATE_NOTIFICATION,
  RDNA_METH_GET_NOTIFICATION_HISTORY,
  RDNA_METH_OPEN_HTTP_CONNECTION
} RDNAMethodID;
```

Method ID | Meaning
--------- | -------
RDNA_METH_NONE  | Not a specific method ID, can be used for generic status update
RDNA_METH_INITIALIZE | Initialize runtime method
RDNA_METH_TERMINATE | Terminate runtime method
RDNA_METH_RESUME | Resume runtime method
RDNA_METH_PAUSE | Pause runtime method
RDNA_METH_GET_CONFIG | GetConfig runtime method
RDNA_METH_CHECK_CHALLENGE | CheckChallenges runtime method
RDNA_METH_UPDATE_CHALLENGE | UpdateChallenges runtime method
RDNA_METH_GET_ALL_CHALLENGES | GetAllChallenges runtime method
RDNA_METH_LOGOFF | Logoff runtime method
RDNA_METH_GET_POST_LOGIN_CHALLENGES | PostLoginChallenges runtime method
RDNA_METH_GET_DEVICE_DETAILS | Self service device management runtime method
RDNA_METH_UPDATE_DEVICE_DETAILS | Update device details runtime method
RDNA_METH_GET_NOTIFICATIONS | Get notifications runtime method
RDNA_METH_UPDATE_NOTIFICATION | Update notifications call back method
RDNA_METH_GET_NOTIFICATION_HISTORY | Get notification history runtime method
RDNA_METH_OPEN_HTTP_CONNECTION | Open http tunnel (same as rest api) connection method

## Service access - Introduction

These structures are used with the backend service access routines. They serve to encapsulate the backend services that are accessed by the API-client application. At a high level, the following lines/bullets describe these structures -

 * Each backend service is represented as a single structure with fields identifying the following information about it -
   * its unique logical name,
   * its target backend coordinate (hostname/IP-address and port number),
   * the access-gateway to connect via, and
   * its locally available access ports
 * An opaque 'service context' pointer is also part of this structure, which needs to be supplied in order to stop the service access via API.
 * The access port structure in turn specifies further details such as -
   * whether the service is started or not,
   * whether the local port is bound to all device network interfaces or not,
   * whether it must be started automatically on initialization or not,
   * whether it requires local privacy (between API-client and the REL-ID DNA) or not, and finally,
   * whether it is accessible locally via a forwarded port or via the proxy facade on the DNA.

## Service access - Port type (enumeration)

These flags specify attributes of the returned access port for the backend service. The meanings of each flag are as follows -

<!--
```c
typedef enum {
  CORE_PORT_TYPE_PROXY = 0,
  CORE_PORT_TYPE_PORTF,
} e_port_type_t;
```
-->

```java
public abstract class RDNA {
  //..
  public enum RDNAPortType {
    RDNA_PORT_TYPE_PROXY(0),
    RDNA_PORT_TYPE_PORTF(1);
  }
  //..
}
```

```objective_c
typedef NS_ENUM (NSInteger, RDNAPortType) {
  RDNA_PORT_TYPE_PROXY = 0x00,
  RDNA_PORT_TYPE_PORTF,
};
```

```cpp
typedef enum {
  RDNA_PORT_TYPE_PROXY = 0x00,
  RDNA_PORT_TYPE_PORTF,
} RDNAPortType;
```

Either one of the below flags is set in the access port structure for a service.

Flag Name | Description
--------- | -----------
PORT_TYPE_PROXY (0) | When set, it specifies that the access port is that of the locally running HTTP proxy facade of the REL-ID DNA, which will transparently tunnel requests and connections to the corresponding backend enterprise service coordinate. In this case, the API-client application would require to assume it is accessing the backend enterprise service via a proxy server on the specified port number.
PORT_TYPE_PORTF (1) | When set, it specifies that the access port is a locally available forwarded TCP port, representing transparent connectivity to the corresponding backend enterprise service coordinate. In this case, the API-client application would require to connect directly to this port, as if it is connecting to the backend enterprise service.


## Service access - Port (class/struct)

Each access port structure consists of a bit-field corresponding to a bunch of boolean flags, and the actual TCP port number for the access port.

<!--
```c
typedef struct
{
  unsigned int isStarted        : 1;
  unsigned int isLocalhostOnly  : 1;
  unsigned int isAutoStarted    : 1;
  unsigned int isPrivacyEnabled : 1;
  unsigned int portType         : 1;
  int port;
} core_port_t;
```
-->

```java
public abstract class RDNA {
  //..
  public static class RDNAPort {
    public boolean isStarted;
    public boolean isLocalhostOnly;
    public boolean isAutoStarted;
    public boolean isPrivacyEnabled;
    public RDNAPortType portType;
    public int port;
  }
  //..
}
```

```objective_c
@interface RDNAPort : NSObject
  @property (nonatomic) BOOL isStarted;
  @property (nonatomic) BOOL isLocalhostOnly;
  @property (nonatomic) BOOL isAutoStarted;
  @property (nonatomic) BOOL isPrivacyEnabled;
  @property (nonatomic) RDNAPortType portType;
  @property (nonatomic) uint16_t port;
@end
```

```cpp
typedef struct RDNAPort_s {
  bool isStarted;
  bool isLocalhostOnly;
  bool isAutoStarted;
  bool isPrivacyEnabled;
  RDNAPortType portType;
  unsigned short  port;
} RDNAPort;
```

Field Name | Data Type | Description
---------- | --------- | -----------
isStarted | bit&nbsp;(boolean) | Specifies whether the service access is enabled. In case of a TYPE_PROXY port, this implies the requests and connections to the corresponding backend enterprise service is enabled. In case of a TYPE_PORTF port, this implies that the locally forwarded port is up and accepting connections on behalf of the backend enterprise service.
isLocalhostOnly | bit&nbsp;(boolean) | Specifies whether the port is bound just on the local loopback interfaces. If not, it is bound on all network interfaces on the device (this is not recommended for enterprise applications)
isAutoStarted | bit&nbsp;(boolean) | Specifies whether the service access was started as part of the API-runtime initialization.
isPrivacyEnabled | bit&nbsp;(boolean) | Specifies whether use of the REL-ID Privacy API routines is mandated, for the data in transit between the API-client application and the REL-ID DNA
portType | bit&nbsp;(boolean) | Specifies whether the port is of TYPE_PROXY (0) or TYPE_PORTF (1), refer ```e_port_type_t```
port | integer | Specifies the actual TCP port number for this service access (could be Proxy or Forwarded Port)

## Service access - Service (class/struct)

The service structure is unique for a given backend service, and specifies the unique logical name, target coordinates (hostname/IP and port number), access gateway details through which to access the service and access port details. It also specifies an opaque coordinate structure to be used when operating on the service using the ServiceAccess* API routines.

<!--
```c
typedef struct
{
  char* serviceName;       /* logical service name         */
  char* targetHNIP;        /* backend hostname/IP          */
  int   targetPort;        /* backend port number          */
  char* accessServerName;  /* access server name           */
  void* serviceCtx;        /* Service context structure    */
  core_port_t portInfo;    /* port setting and info        */
} core_service_t;
```
-->

```java
public abstract class RDNA {
  //..
  public static class RDNAService {
    public String serviceName;
    public String targetHNIP;
    public int targetPort;
    public RDNAPort portInfo;
  }
  //..
}
```

```objective_c
@interface RDNAService : NSObject
  @property (nonatomic, copy) NSString *serviceName;
  @property (nonatomic, copy) NSString *targetHNIP;
  @property (nonatomic) uint16_t targetPort;
  @property (nonatomic) RDNAPort *portInfo;
@end
```

```cpp
typedef struct RDNAService_s {
  std::string serviceName;
  std::string targetHNIP;
  unsigned short targetPort;
  RDNAPort portInfo;
} RDNAService;
```

Field Name | Data Type | Description
---------- | --------- | -----------
serviceName | null-terminated string | Unique logical name of the backend service (as configured in REL-ID Gateway Manager)
targetHNIP | null-terminated string | The notional hostname/IP-address of the TCP coordinate of the backend service
targetPort | integer | The notional port number of the TCP coordinate of the backend service
accessServerName | null-terminated string | <b><u><i>Only in Core API</i></u></b><br>Unique logical name of the Access Gateway Server through which this service is accessible
serviceCtx | opaque-reference | <b><u><i>Only in Core API</i></u></b><br>Opaque context reference to be used when starting/stoping the ServiceAccess via the API routines
portInfo | access port structure | The access port structure corresponding to the service provided

## RDNAChallenge (class/struct)

As part of the user authentication process, the server throws one or more challenges to which the client needs to respond. These could either be individual challenges, or a set of challenges. The following table describes the individual elements represents the challenge struct/object.

```java
public abstract class RDNA {
  //...
  public static class RDNAChallenge {
    public String name;
    public RDNA.RDNAChallengePromptType type;
    public int index;
    int subChallengeIndex;
    public RDNA.RDNAChallengeInfo[] info;      
    public String[] prompts;
    public int attemptsLeft;
    public boolean shouldValidateResponse;
    public String[] responsePolicies;
    public String responseKey;
    public Object responseValue;
    public RDNA.RDNAChallengeOpMode challengeOperation;
}
}
```

```objective_c
@interface RDNAChallenge : NSObject

    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, assign, readonly) RDNAChallengePromptType type;
    @property (nonatomic, assign, readonly) int index;
    @property (nonatomic, assign, readonly) int subChallengeIndex;
    @property (nonatomic, strong, readonly) NSMutableArray<RDNAChallengeInfo *> *info;
    @property (nonatomic, strong, readonly) NSArray *prompts;
    @property (nonatomic, assign, readonly) int attemptsLeft;
    @property (nonatomic, assign, readonly) BOOL shouldValidateResponse;
    @property (nonatomic, strong, readonly) NSArray *responsePolicies;
    @property (nonatomic, strong) NSString *responseKey;
    @property (nonatomic, strong) NSObject *responseValue;
    @property (nonatomic) RDNAChallengeOpMode challengeOperation;

@end
```

```cpp
typedef struct RDNAChallenge_s{
  const std::string name;
  RDNAChallengePromptType type;
  const int index;
  const vector<RDNAChallengeInfo> info;
  const vector<std::string> prompts;
  const int attemptsLeft;
  const bool shouldValidateResponse;
  const int responseCount;
  const vector<std::string> responsePolicies;
  const std::string chlngDetails;
  std::string response;
  const std::string responseKey;
  std::string responseValue;
  RDNAChallengeOpMode challengeOperation;
} RDNAChallenge;
```

Member | Description
------ | -----------
<b>name</b> | This is the name of the challenge (secqa, username, password, access code, etc... )
<b>prompts</b> | This field is an array of prompts.
<b>type</b> | This is the type of the prompt. The possible prompt types are RDNA_PROMPT_BOOLEAN, RDNA_PROMPT_ONE_WAY and RDNA_PROMPT_TWO_WAY. RDNA_PROMPT_BOOLEAN represents a challenge, for which the response is a boolean type (true/1/yes or false/0/no).  
<b>index</b> | This is the index of the challenge within the set of challenges being presented. This is used by the DNACore to make sure that the responses to the challenges are provided in the same sequence as the challenges.
<b>info</b> | The ChallengeInfo struct/object contains data specific to the challenge, and is implementation specific. For instance, it may contain text describing the challenge, and could be useful as a tooltip for UI elements.
<b>attemptsLeft</b> | Represents the number of valid attempts remaining before the user is either SUSPENDED or BLOCKED.
<b>shouldValidateResponse</b> | This value represents whether the API client has to validate the user entered values at client end.
<b>responsePolicies</b> | The policies to be applied on user entered values, these policies can be like regular expression to be applied on user input.
<b>responseKey</b> | This represents the actual challenge shown to the user. The actual key depends on the type of the type of challenge being thrown. For instance, in case of activation, the ```responseKey``` field will contain the activation code, and the user is expected to provide the verification key as the value. In case of secret QA, the ```responseKey``` will represent the secret question, and the ```responseValue``` field should contain the secret answer.
<b>responseValue</b> | This should be set by the API client. This is the value which user enter for authentication.
<b>challengeOperation</b> | This indicates if the challenge is thrown by the server for authenticating the user or the server asking the user to set the challenge for use in future  authentication attempts.

## RDNAChallengePromptType (Enumeration)

The RDNAChallengeType is an enumeration of types of challenge prompts. A prompt represents a piece of information needed by the end user to respond to the challenge. <br><br>For instance, in the case of Secret QA (where the challenge name is secqa), there could either be a single prompt or multiple prompts, each prompt representing a secret question. For password challenge, the prompt array would be empty, since the user does not need any information to enter the password.

```java
public abstract class RDNA {
  //...
  public static enum RDNAChallengeType{
    RDNA_PROMPT_BOOLEAN (0),
    RDNA_PROMPT_ONE_WAY (1),
    RDNA_PROMPT_TWO_WAY (2);

    public final int intValue;

    private RDNAChallengeType(int val) {
      this.intValue = val;
    }
  }
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAChallengePromptType) {
  RDNA_PROMPT_BOOLEAN = 0,
  RDNA_PROMPT_ONE_WAY,
  RDNA_PROMPT_TWO_WAY,
};
```

```cpp
typedef enum{
  RDNA_PROMPT_BOOLEAN = 0,
  RDNA_PROMPT_ONE_WAY,
  RDNA_PROMPT_TWO_WAY,
} RDNAChallengePromptType;
```

PromptType | Description
---------- | -----------
<b>RDNA_PROMPT_BOOLEAN</b> | Represents a challenge where the user needs to respond with either a positive value (true/1/yes) or a negative response (false/0/no).<br><b>E.g. Setting the device binding as temporary or permanent.</b>
<b>RDNA_PROMPT_ONE_WAY</b> | Represents a challenge where the user needs to respond to the challenge and this response is independent of any additional information provided.<br><b>E.g. A challenge asking for the username or the challenge asking for the password<b>.
<b>RDNA_PROMPT_TWO_WAY</b> | Represents a challenge where the ISA would provide some information to the client (represented by an array of prompts), and the user response to the challenge depends on the provided information.<br><b>E.g. A challenge where the user is expected to set the secret question and the secret answer.</b>


## RDNAResponseStatusCode (Enumeration)

The ```RDNAResponseStatusCode``` represents the result of the previous API server response such as ```CheckChallengeResponse``` or ```UpdateChallenge``` ```getRegisteredDeviceDetails``` etc.  

```java
public abstract class RDNA {
  //...
  public static enum RDNAResponseStatusCode {
    RDNA_RESP_STATUS_SUCCESS(0),
    RDNA_RESP_STATUS_NO_SUCH_USER(1),
    RDNA_RESP_STATUS_USER_SUSPENDED(2),
    RDNA_RESP_STATUS_USER_BLOCKED(3),
    RDNA_RESP_STATUS_USER_ALREADY_ACTIVATED(4),
    RDNA_RESP_STATUS_INVALID_ACT_CODE(5),
    RDNA_RESP_STATUS_UPDATE_CHALLENGES_FAILED(6),
    RDNA_RESP_STATUS_RESPONSE_VALIDATION_FAILED(7),
    RDNA_RESP_STATUS_DEVICE_VALIDATION_FAILED(8),
    RDNA_RESP_STATUS_INVALID_CHALLENGE_LIST(9),
    RDNA_RESP_STATUS_INTERNAL_SERVER_ERROR(10),
    RDNA_RESP_STATUS_FAILED_UPDATE_DEVICE_DETAILS(11),
    RDNA_RESP_STATUS_NO_SUCH_USE_CASE_EXISTS(12),
    RDNA_RESP_STATUS_ATTEMPTS_EXHAUSTED(13),
    RDNA_RESP_STATUS_UNKNOWN_ERROR(14);
  }
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAResponseStatusCode) {
  RDNA_RESP_STATUS_SUCCESS = 0,
  RDNA_RESP_STATUS_NO_SUCH_USER,
  RDNA_RESP_STATUS_USER_SUSPENDED,
  RDNA_RESP_STATUS_USER_BLOCKED,
  RDNA_RESP_STATUS_USER_ALREADY_ACTIVATED,
  RDNA_RESP_STATUS_INVALID_ACT_CODE,
  RDNA_RESP_STATUS_UPDATE_CHALLENGES_FAILED,
  RDNA_RESP_STATUS_RESPONSE_VALIDATION_FAILED,
  RDNA_RESP_STATUS_DEVICE_VALIDATION_FAILED,
  RDNA_RESP_STATUS_INVALID_CHALLENGE_LIST,
  RDNA_RESP_STATUS_INTERNAL_SERVER_ERROR,
  RDNA_RESP_STATUS_FAILED_UPDATE_DEVICE_DETAILS,
  RDNA_RESP_STATUS_NO_SUCH_USE_CASE_EXISTS,
  RDNA_RESP_STATUS_ATTEMPTS_EXAUSTED,
  RDNA_RESP_STATUS_UNKNOWN_ERROR
};
```

```cpp
typedef enum {
  RDNA_RESP_STATUS_SUCCESS = 0,
  RDNA_RESP_STATUS_NO_SUCH_USER,
  RDNA_RESP_STATUS_USER_SUSPENDED,
  RDNA_RESP_STATUS_USER_BLOCKED,
  RDNA_RESP_STATUS_USER_ALREADY_ACTIVATED,
  RDNA_RESP_STATUS_INVALID_ACT_CODE,
  RDNA_RESP_STATUS_UPDATE_CHALLENGES_FAILED,
  RDNA_RESP_STATUS_RESPONSE_VALIDATION_FAILED,
  RDNA_RESP_STATUS_DEVICE_VALIDATION_FAILED,
  RDNA_RESP_STATUS_INVALID_CHALLENGE_LIST,
  RDNA_RESP_STATUS_INTERNAL_SERVER_ERROR,
  RDNA_RESP_STATUS_FAILED_UPDATE_DEVICE_DETAILS,
  RDNA_RESP_STATUS_NO_SUCH_USE_CASE_EXISTS,
  RDNA_RESP_STATUS_ATTEMPTS_EXHAUSTED,
  RDNA_RESP_STATUS_UNKNOWN_ERROR

} RDNAResponseStatusCode;
```

ChallengeStatus | Description
--------------- | -----------
<b>RDNA_CHLNG_STATUS_SUCCESS</b> | This status is returned when the response to the challenge has been deemed verified
<b>RDNA_CHLNG_STATUS_NO_SUCH_USER</b> | This status is returned when the specified user does not exist. The client either needs to correct the username or enroll the username through the Gateway Manager.
<b>RDNA_CHLNG_STATUS_USER_SUSPENDED</b> | This status is returned when the specified user is in a SUSPENDED state. The administrator needs to unblock the user before the authentication can proceed.
<b>RDNA_CHLNG_STATUS_USER_BLOCKED</b> | This status is returned when the specified user is in a BLOCKED state. The administrator needs to unblock the user before the authentication can proceed.
<b>RDNA_CHLNG_STATUS_USER_ALREADY_ACTIVATED</b> | This status is returned when the user specified in the challenge has already been activated, yet the system is attempting to activate the user. In this case client needs to restart the user authentication sequence.
<b>RDNA_CHLNG_STATUS_INVALID_ACT_CODE</b> | This status is returned when the user has entered an invalid activation code. The user needs to enter the appropriate activation code for the authentication to proceed.
<b>RDNA_CHLNG_STATUS_UPDATE_CHALLENGES_FAILED</b> | This code is returned when the user has attempted to update the challenges, and server has failed to update them.
<b>RDNA_CHLNG_STATUS_RESPONSE_VALIDATION_FAILED</b> | This code is returned when the server has failed to verify the user's response to a challenge. The server will usually present the challenges once again and the user needs to reattempt to respond to the challenges.
<b>RDNA_CHLNG_STATUS_DEVICE_VALIDATION_FAILED</b> | This status is returned when the device from which the user is attempting to authenticate himself has been rejected by the server based on some policy.
<b>RDNA_CHLNG_STATUS_INVALID_CHALLENGE_LIST</b> |  This status is returned by the server when it recieves improper challenge response for that state. The usual solution for this would be to restart the authentication sequence.
<b>RDNA_CHLNG_STATUS_INTERNAL_SERVER_ERROR</b> | This status is returned when an internal server error has occurred. The only recourse is to contact the administrator.
<b>RDNA_RESP_STATUS_FAILED_UPDATE_DEVICE_DETAILS</b> | This status is returned when update the device details at server is failed
<b>RDNA_RESP_STATUS_NO_SUCH_USE_CASE_EXISTS</b> | This status is returned when the use case specified in post login challenges is not configured in server
<b>RDNA_RESP_STATUS_ATTEMPTS_EXHAUSTED</b> | This status is returned when all the Challenge attempts exhausted
<b>RDNA_CHLNG_STATUS_UNKNOWN_ERROR</b> | This status is returned when an error or unknown origin has occurred. The only recourse is to contact the administrator.

## RDNAChallengeOpMode (Enumeration)

This enumeration is used to indicate to the user about the intended action for the challenge, namely whether this is a challenge verification operation or a challenge update operation.

```java
public abstract class RDNA {
  //...
  public static enum RDNAChallengeOpMode{
    RDNA_CHALLENGE_OP_VERIFY (0),
    RDNA_CHALLENGE_OP_SET (1);
  }
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAChallengeOpMode) {
  RDNA_CHALLENGE_OP_VERIFY = 0,
  RDNA_CHALLENGE_OP_SET
};
```

```cpp
typedef enum{
  RDNA_CHALLENGE_OP_VERIFY = 0,
  RDNA_CHALLENGE_OP_SET
} RDNAChallengeOpMode;
```

ChallengeOpMode | Description
--------------- | -----------
<b>RDNA_CHALLENGE_OP_VERIFY</b> | This implies that the challenge response would be verified by the server against the known correct response.
<b>RDNA_CHALLENGE_OP_SET</b>    | This implies that the provided response would be marked by the server as the known correct response, and would be used to compare against the challenge response provided for the same challenge at a later point of time.

## RDNAResponseStatus

This class defines the status of the response of previous challenge recieved by the server. The following are the members of the class :

```java
public abstract class RDNA {
  //...
  public static class RDNAResponseStatus{
    public String message;
    public RDNAResponseStatusCode statusCode;

    public RDNAResponseStatus(String message, RDNAResponseStatusCode statusCode) {
      this.message = message;
      this.statusCode = statusCode;
    }
  }
}
```

```objective_c
@interface RDNAResponseStatus : NSObject
  @property (nonatomic, strong) NSString *message;
  @property (nonatomic, assign) RDNAResponseStatusCode statusCode;
@end
```

```cpp
typedef struct RDNAResponseStatus_s {
  std::string message;
  RDNAResponseStatusCode statusCode;
  RDNAResponseStatus_s () : message(""), statusCode(RDNA_RESP_STATUS_SUCCESS)
  {}
} RDNAResponseStatus;
```

Member | Description
------ | -----------
<b>message</b> | This is a string representation of the error that occurred. This would be implementation specific.
<b>statusCode</b> | This is the statusCode representing the error that occurred during the processing of the challenge response.

## DeviceStatus (Enumeration)
Following enums are defined for the device management feature, which will provide the device details of a specific device, for example the device status and device binding

```java
public abstract class RDNA {
  //...
  public static enum RDNADeviceStatus {
    RDNA_DEVSTATUS_ACTIVE(0),
    RDNA_DEVSTATUS_UPDATE(1),
    RDNA_DEVSTATUS_DELETE(2),
    RDNA_DEVSTATUS_BLOCKED(3),
    RDNA_DEVSTATUS_SUSPEND(4),
  }

  public static enum RDNADeviceBinding {
    RDNA_PERMENANT(0),
    RDNA_TEMPORARY(1),
  }
  //...
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNADeviceStatus) {
  RDNA_DEVSTATUS_ACTIVE = 0,
  RDNA_DEVSTATUS_UPDATE,
  RDNA_DEVSTATUS_DELETE,
  RDNA_DEVSTATUS_BLOCKED,
  RDNA_DEVSTATUS_SUSPEND,
};

typedef NS_ENUM(NSInteger, RDNADeviceBinding) {
  RDNA_PERMENANT = 0,
  RDNA_TEMPORARY,
};
```

```cpp
enum RDNADeviceStatus {
  RDNA_DEVSTATUS_ACTIVE,
  RDNA_DEVSTATUS_UPDATE,
  RDNA_DEVSTATUS_DELETE,
  RDNA_DEVSTATUS_BLOCKED,
  RDNA_DEVSTATUS_SUSPEND,
};

enum RDNADeviceBinding {
  RDNA_PERMENANT,
  RDNA_TEMPORARY
};
```


# API - Initialize-Terminate

## Initialize Routine

This is the first routine that must be called to bootstrap the REL-ID API runtime. The arguments to this routine are described in the below table.

This routine starts up the API runtime (including a DNA - <i>Digital Network Adapter</i> - instance), and in the process registers the API-client supplied callback routines with the API runtime context. This is a non-blocking routine, and when it returns, it will have initiated the process of creation of a REL-ID session in PRIMARY state, using the supplied <i>agent information</i> - the progress of this operation is notified to the API-client application via the status update (core API), and event notification (wrapper API) callback routines provided in the initialize routine.

A reference to the context of the newly created API runtime is returned to the API-client.

<!--
```c
int
coreInitialize
(void** ppvRuntimeCtx,
 char*  sAgentInfo,
 core_callbacks_t*
        pCallbacks,
 char*  sAuthGatewayHNIP,
 int    nAuthGatewayPORT,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 proxy_settings_t*
        pProxySettings,
 core_ssl_certificate*
        pSSLCertificate,
 void*  pvAppCtx);
```
-->

```java
public abstract class RDNA {
  //..
  public static
  RDNA.RDNAStatus<RDNA> Initialize
        (String agentInfo,
         RDNA.RDNACallbacks callbacks,
         String authGatewayHNIP,
         int authGatewayPORT,
         String cipherSpecs,
         String cipherSalt,
         RDNA.RDNAProxySettings proxySettings,
         RDNA.RDNASSLCertificate sslCertificate,
         String[] dnsServer,
         RDNA.RDNALoggingLevel loggingLevel,
         Object appCtx);
  //..
}
```

```objective_c
@interface RDNA : NSObject
  + (int)initialize:(RDNA **)ppRuntimeCtx
          AgentInfo:(NSString *)agentInfo
          Callbacks:(id<RDNACallbacks>)callbacks
        GatewayHost:(NSString *)authGatewayHNIP
        GatewayPort:(uint16_t)authGatewayPORT
         CipherSpec:(NSString *)cipherSpec
         CipherSalt:(NSString *)cipherSalt
      ProxySettings:(RDNAProxySettings *)proxySettings
 RDNASSLCertificate:(RDNASSLCertificate*)rdnaSSLCertificate
      DNSServerList:(NSArray<NSString*>*)dnsServerList
  RDNALoggingLevel :(RDNALoggingLevel)loggingLevel

         AppContext:(id)appCtx;
@end
```

```cpp
class RDNA
{
public:
  static int
  initialize
  (RDNA**             ppRuntimeCtx,
   std::string        agentInfo,
   RDNACallbacks*     callbacks,
   std::string        authGatewayHNIP,
   unsigned short     authGatewayPORT,
   std::string        cipherSpec,
   std::string        cipherSalt,
   RDNAProxySettings* proxySettings,
   RDNASSLCerts*      sslCerts,
   vector<std::string> DNSServers,
   RDNALoggingLevel   eLogLevel,
   void*              appCtx);
}
```

Argument&nbsp;[in/out] | Description
---------------------- | -----------
API Context [out] | The newly created API runtime context.<br>In Java, an instance of ```RDNA``` is returned in an ```RDNAStatus<RDNA>``` object.<br>In Core, Objective-C and C++, an out parameter is populated.
Agent Info [in] | Software identity information for the API-runtime to authenticate and establish primary session connectivity with the REL-ID platform backend along with security threat policy to check for device threats.
Callbacks [in] | Callback routines supplied by the API-client application. These are invoked by the API-runtime.
Auth Gateway HNIP [in] | <b>H</b>ost<b>N</b>ame/<b>IP</b>-address of the REL-ID Authentication Gateway against which the API-runtime must establish mutual authenticated connectivity (on behalf of the API-client application).
Auth Gateway PORT [in] | <b>PORT</b>-number at ```AuthGatewayHNIP```, on which the REL-ID Authentication Gateway is accessible (accepting connections).
Cipher Specs [in] | The cipher specifications (encryption algorithm, padding scheme and cipher-mode) to be used as a default for this API-Runtime context. If passed as empty, then the default Cipher Spec of the API-SDK will be used as default.
Cipher Salt [in] | The salt/IV to be used as default salt/IV for this API-Runtime context. If passed as empty, then the default Cipher Salt of the API-SDK will be used as default.
Application Context [in] | Opaque reference to API-client application context that is never interpreted/modified by the API-runtime. This reference is supplied with each callback invocation to the API-client.
Proxy Settings [in] |Hostname/IPaddress and port-number for proxy to use when connecting to the Auth Gateway server. This is an optional parameter that may be null if it is not applicable
SSL Certificates[in] | The SSL Certificates in P12 format (which is base64-encoded) and password used to generate the certificates is provided to enable SSL over RMAK. This is an optional parameter. If it is specified as NULL, the SDK will not perform SSL over RMAK.
DNS Servers [in] | A list of IP address to perform DNS host name resolution for Hostname provided to the DNA.
Log Level [in] | Enable / Disable SDK logs based on the provided log level.


## Terminate Routine

<!--
```c
int
coreTerminate
(void*  pvRuntimeCtx);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract int terminate();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  - (int)terminate;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  int terminate();
  //..
}
```

Routine | Description
------- | -----------
<b>Terminate</b> | API runtime shutdown is initiated - including freeing up memory and other resources, and stopping of the DNA.

# API - Sessions

The REL-ID Session is issued to the client-side as an opaque ticket from the REL-ID backend. This ticket is subsequently used by the client-side API-runtime to gain access to backend enterprise services.

There are 2 types of REL-ID sessions - PRIMARY and SECONDARY:

 * <b>PRIMARY</b> (app) session - The Basic API Initialize routine creates a session associated with (i) the application identity (AgentInfo), and (ii) the device identity (or fingerprint). This session is called a <b>PRIMARY</b> session.
 * <b>SECONDARY</b> (user) session - Upon successful end-user authentication, a new session ticket is issued to the client, which additionally associates a 3rd identity - (iii) the identity of the user. This session is called a <b>SECONDARY</b> session.

<aside class="notice"><u><b>SECONDARY (user) sessions</b> are part of the <b>Advanced API</b></u>.<br>Explained here just to put the types of sessions in perspective.</aside>

<aside class="notice"><b><u>Sessions are persistent</u></b><br>
The <b>PauseRuntime</b> routine returns the <i>in-session</i> state of the API-runtime includes the session tickets and their access configurations as well. This returned state may be persisted and reloaded into the API-runtime with the call to <b>ResumeRuntime</b>, to recreate the runtime state along with the session information required for accessing backend services.
</aside>

When an API-client application no longer requires a session, for example when the end-user logs of the enterprise application, it can invoke the ```logoff``` (to terminate user session) and/or ```terminate``` (to terminate the user and app session) routines to notify the REL-ID backend that the session is no longer valid and is not to be entertained anymore.

After the formation of user session - the app session is subsided by saving its state, the services related to app session is shutdown and the services related to user session is started. Hence after the invalidation of user session, the app session is again restored and the services related to app session is started as per its last subsided state.

# API - Service Access

These routines enable the API-client applications to retrieve the service structure for the backend enterprise service it requires to interact with, and use that information to safely interact with them.
 * The first 2 ```GetService...``` routines help retrieve the service information for the service - one of them looks it up using a logical unique name of the backend service and the other retrieves all available services for the current context
 * The second 2 ```ServiceAccess...``` routines are used to start/enable and stop/disable the access to the backend services.

## Information Retrieval

<!--
```c
int
coreGetServiceByServiceName
(void*  pvRuntimeCtx,
 char*  sServiceName,
 core_service_t**
        ppService);

int
coreGetServiceByTargetCoordinate
(void*  pvRuntimeCtx,
 char*  sTargetHNIP,
 int    nTargetPORT,
 core_service_t***
        ppServices);

int
coreGetAllServices
(void*  pvRuntimeCtx,
 core_service_t***
        ppServices);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract
    RDNAStatus<RDNAService>
    getServiceByServiceName
    (String serviceName);

  public abstract
    RDNAStatus<RDNAService[]>
    getServiceByTargetCoordinate
    (String targetHNIP, int targetPORT);

  public abstract
    RDNAStatus<RDNAService[]>
    getAllServices();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  - (int)getServiceByServiceName:(NSString *)serviceName;
                     ServiceInfo:(RDNAService **)service

  - (int)getServiceByTargetCoordinate:(NSString *)targetHNIP
                           TargetPort:(int)targetPORT
                         ServicesInfo:(NSArray **)services

  - (int)getAllServices:(NSArray **)services;
@end
```

```cpp
class RDNA
{
public:
  int
  getServiceByServiceName
  (std::string  serviceName,
   RDNAService& service);

  int
  getServiceByTargetCoordinate
  (std::string   targetHNIP,
   unsigned port targetPORT,
   vector<RDNAService>&
                 services);

  int
  getAllServices
  (vector<RDNAService>&
                services);
}
```

Routine&nbsp;Name | Description
----------------- | -----------
<b>GetServiceByServiceName</b> | Retrieve the ```Service``` structure by looking up the unique logical name of the backend service (as configured in the REL-ID Gateway Manager)
<b>GetServiceByTargetCoordinate</b> | Retrieve one or more ```Service``` structure(s) by looking up the target (masked) coordinate, corresponding to the backend enterprise service. More than one services could be returned, depending on the access configuration for the context.
<b>GetAllServices</b> | Retrieve the ```Service``` structures for all available services that are accessible via the current API-runtime context and the session within.

## Start/Stop Access

<!--
```c
int
coreServiceAccessStart
(void*  pvRuntimeCtx,
 core_service_t*
        pService);

int
coreServiceAccessStop
(void*  pvRuntimeCtx,
 core_service_t*
        pService);

int
coreServiceAccessStartAll
(void*  pvRuntimeCtx);

int
coreServiceAccessStopAll
(void*  pvRuntimeCtx);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract int serviceAccessStart (RDNAService service);
  public abstract int serviceAccessStop  (RDNAService service);
  public abstract int serviceAccessStartAll();
  public abstract int serviceAccessStopAll();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  - (int)serviceAccessStart:(const RDNAService *)service;
  - (int)serviceAccessStop:(const RDNAService *)service;
  - (int)serviceAccessStartAll;
  - (int)serviceAccessStopAll;
@end
```

```cpp
class RDNA
{
public:
  int serviceAccessStart(const RDNAService svc);
  int serviceAccessStop(const RDNAService svc);
  int serviceAccessStartAll();
  int serviceAccessStopAll();
}
```

Routine&nbsp;Name | Description
----------------- | -----------
<b>ServiceAccessStart</b> | Access to the service (i.e. the corresponding backend enterprise service) via the access port for the ```Service``` is started<li>In case of ```TYPE_PROXY``` port, the proxy facade of the DNA in the API-runtime listening on that port will start <i>tunneling</i> requests/data to the corresponding backend service.<li>In case of ```TYPE_PORTF``` port, the corresponding forwarded TCP port is started in the DNA in the API-runtime, and made ready to accept connections from which data will be transparently forwarded to the corresponding backend service.
<b>ServiceAccessStop</b> | Access to the service (i.e. the corresponding backend enterprise service) via the access port for the ```Service``` is stopped<li>In case of ```TYPE_PROXY``` port, the proxy facade of the DNA in the API-runtime listening on that port will stop <i>tunneling</i> requests/data to the corresponding backend service and it will revert with an appropriate HTTP Proxy error code for further access to this service<li>In case of ```TYPE_PORTF``` port, the corresponding forwarded TCP port is shutdown and closed in the DNA in the API-runtime, and connections to that port will no longer be accepted.

# API - Data Privacy

The data privacy provided to the API-client application, is delivered at different scopes - each scope sets how the privacy (encryption) keys are generated and used. Further, 3 types of encryption/decryption functionality is provided - across all supported privacy scopes -
 # Raw Data Packets: Encryption and decryption of raw data packets
 # HTTP Requests and Responses: Encryption of HTTP requests and decryption of HTTP responses
 # Privacy Streams: An in-memory buffered stream abstraction for encryption and decryption

## Scopes/Levels

<!--
```c
typedef enum {
  CORE_PRIVACY_SCOPE_SESSION = 0x01, /* use session-specific keys */
  CORE_PRIVACY_SCOPE_DEVICE  = 0x02, /* use device-specific keys  */
  CORE_PRIVACY_SCOPE_USER    = 0x03, /* use user-specific keys    */
  CORE_PRIVACY_SCOPE_AGENT   = 0x04, /* use agent-specific keys   */
} e_core_privacy_scope_t;
```
-->

```java
public abstract class RDNA {
  //..
  public enum RDNAPrivacyScope {
    RDNA_PRIVACY_SCOPE_SESSION(1), /* use session-specific keys */
    RDNA_PRIVACY_SCOPE_DEVICE(2),  /* use device-specific keys */
    RDNA_PRIVACY_SCOPE_USER(3),    /* use user-specific keys */
    RDNA_PRIVACY_SCOPE_AGENT(4);   /* use agent-specific keys */
  }
  //..
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAPrivacyScope) {
  RDNA_PRIVACY_SCOPE_SESSION = 0x01,  /* use session-specific keys */
  RDNA_PRIVACY_SCOPE_DEVICE = 0x02,   /* use device-specific keys  */
  RDNA_PRIVACY_SCOPE_USER = 0x03,     /* use user-specific keys    */
  RDNA_PRIVACY_SCOPE_AGENT = 0x04,    /* use agent-specific keys   */
};
```

```cpp
typedef enum {
  RDNA_PRIVACY_SCOPE_SESSION = 0x01, /* use session-specific keys */
  RDNA_PRIVACY_SCOPE_DEVICE  = 0x02, /* use device-specific keys  */
  RDNA_PRIVACY_SCOPE_USER    = 0x03, /* use user-specific keys    */
  RDNA_PRIVACY_SCOPE_AGENT   = 0x04, /* use agent-specific keys   */
} RDNAPrivacyScope;
```

Scope | Description
----- | -----------
RDNA_PRIVACY_SCOPE_SESSION | Keys used are specific to the REL-ID session and valid for duration of the session.<br>Used to secure the privacy of data in transit between the API-client application and the REL-ID DNA, as well as between the API-client application and its backend services.<br>Depending on the current state of the API-Runtime, the retrieved key will be either belonging to the current application (PRIMARY) REL-ID session or to the current user (SECONDARY) REL-ID session.
RDNA_PRIVACY_SCOPE_DEVICE | Keys used are specific to the end-point device.<br>Used by the API-client application to secure the privacy of persistent data that the API-client application would store on the device.
RDNA_PRIVACY_SCOPE_USER | Keys used are specific to the authenticated user-identity.<br>This is relevant ONLY when the Advanced API (User-Interaction) is used.
RDNA_PRIVACY_SCOPE_AGENT | Keys used are specific to the agent (i.e. the application using the API)


## Cipher Specifications

The cipher specification details contain the cipher algorithm to be used for encryption/decryption (along with its key length, mode and padding) and the digest algorithm to be used for generating HMAC (Hash-based message authentication code) of the encrypted data for data integrity check.
The format for cipher specification is [CIPHER_ALGO_SPECS]:[DIGEST_ALGO_SPECS].
For example: AES/256/CBC/PKCS7Padding:SHA-1, where "AES/256/CBC/PKCS7Padding" is the cipher algorithm specification and "SHA-1" is the HMAC digest specification (optional).

The API-Client can also choose to use default Cipher Spec ("AES/256/CFB/PKCS7Padding:SHA-256") and default Cipher Salt/IV available in the API-SDK. The API-Client can get the default Cipher Spec and Salt of the API-Runtime context using the GetDefaultCipherSpec and GetDefaultCipherSalt APIs. These default CipherSpec and CipherSalt can be overridden by passing these information in the ```Initialize``` API.

The API-Client can use a separate Cipher Spec and Salt/IV for a specific call of Data Privacy APIs or can send empty details to use the default Cipher Spec and Salt/IV. But note that while using the Data Privacy APIs for session-scope privy service, the API-Client should make sure that it either sends empty or same CipherSpec/Salt as the default so that service provider can make use of the encrypted data.

<aside class="notice"><b><u>Session-Scope Cipher Details</u></b> -
<br>
The way in which session-scope privacy works is as follows:
<li>The API-client application invokes an <u>Encrypt</u> API routine with <i>Session</i> privacy scope and sends the encrypted data via an access port
<li>The DNA receives the data and decrypts it, before sending the data across to the backend service
<li>The DNA receives the response from the backend service, and encrypts it before sending it back to the API-client application
<li>The API-client application receives the encrypted response, and subsequently invokes a <u>Decrypt</u> API routine  with <i>Session</i> privacy scope before processing the plaintext response.
<li>Hence the API-Client should make sure that it either sends empty or same CipherSpec/Salt as the default so that service provider can make use of the encrypted data. The DNA will use the default cipher details (can be overridden by the supplied details in the <u>Initialize</u> routine).
</aside>

<!--
```c
int
coreGetDefaultCipherSpec
(void*  pvRuntimeCtx,
 char** psDefCipherSpecs);

int
coreGetDefaultCipherSalt
(void*  pvRuntimeCtx,
 char*  sDefCipherSalt);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract RDNAStatus<String> getDefaultCipherSpec();
  public abstract RDNAStatus<byte[]> getDefaultCipherSalt();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  - (int)getDefaultCipherSpec:(NSMutableString **)cipherSpec;
  - (int)getDefaultCipherSalt:(NSMutableString **)cipherSalt;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  int getDefaultCipherSpec(std::string& cipherSpec);
  int getDefaultCipherSalt(std::string& cipherSalt);
  //..
}
```

Routine | Description
----- | -----------
GetDefaultCipherSpec | Get the default cipher spec used in the RDNA context
GetDefaultCipherSalt | Get the default cipher salt used in the RDNA context


List of supported cipher algorithm -

  Cipher algo  | Key length |   Mode   |  Padding
-------------- | ---------- | -------- | ---------
<li>AES | <li>128<li>192<li>256 | <li>ECB<li>CBC<li>PCBC<li>CFB<li>OFB<li>CTR | <li>NoPadding<li>PKCS7Padding<li>ISO10126Padding


List of supported digest algorithm -

 * MD5
 * SHA-1
 * SHA-256
 * SHA-384
 * SHA-512


## Raw Data (in packets)

<!--
```c
int
coreEncryptDataPacket
(void*  pvRuntimeCtx,
 e_core_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 void*  plainText,
 int    plainTextLen,
 void** cipherText,
 int*   cipherTextLen);

int
coreDecryptDataPacket
(void*  pvRuntimeCtx,
 e_core_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 void*  cipherText,
 int    cipherTextLen,
 void** plainText,
 int*   plainTextLen);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract
    RDNAStatus<byte[]>
    encryptDataPacket(
      RDNAPrivacyScope
             privacyScope,
      String cipherSpec,
      byte[] cipherSalt,
      byte[] plainText);

  public abstract
    RDNAStatus<byte[]>
    decryptDataPacket(
      RDNAPrivacyScope
             privacyScope,
      String cipherSpec,
      byte[] cipherSalt,
      byte[] cipherText);
  //..
}
```

```objective_c
@interface RDNA : NSObject
  - (int)encryptDataPacket:(RDNAPrivacyScope)privacyScope
                CipherSpec:(NSString *)cipherSpec
                CipherSalt:(NSString *)cipherSalt
                      From:(NSData *)plainText
                      Into:(NSMutableData **)cipherText;

  - (int)decryptDataPacket:(RDNAPrivacyScope)privacyScope
                CipherSpec:(NSString *)cipherSpec
                CipherSalt:(NSString *)cipherSalt
                      From:(NSData *)cipherText
                      Into:(NSMutableData **)plainText;
@end
```

```cpp
class RDNA
{
public:
  int
  encryptDataPacket
  (RDNAPrivacyScope
               privacyScope,
   std::string cipherSpec,
   std::string cipherSalt,
   void*       plainText,
   int         plainTextLen,
   void**      cipherText,
   int*        cipherTextLen);

  int
  decryptDataPacket
  (RDNAPrivacyScope
               privacyScope,
   std::string cipherSpec,
   std::string cipherSalt,
   void*       cipherText,
   int         cipherTextLen,
   void**      plainText,
   int*        plainTextLen);
}
```

Routine | Description
------- | -----------
<b>EncryptDataPacket</b> | <li>Raw plaintext (unencrypted) data is supplied as a buffer of bytes.<li>This data is encrypted using keys as per specified privacy scope, and returned to calling API-client application.
&nbsp; | ANSI C, C++ -<li>If the supplied ```cipherText``` and ```cipherTextLen``` are non-null, they are used to store the encrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)
&nbsp; | Java, Objective C -<li>The output is always returned as a newly allocated array/buffer (```byte[]``` in Java, ```NSMutableData **``` in Objective C)
<b>DecryptDataPacket</b> | <li>Encrypted data is supplied as a buffer of bytes.<li>This data is decrypted using keys as per specified privacy scope, and returned to calling API-client application.
&nbsp; | ANSI C, C++ -<li>If the supplied ```plainText``` and ```plainTextLen``` are non-null, they are used to store the decrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)<li>Recommended method is to supply input encrypted buffer itself in these output parameters, since it will definitely be larger than or equal to what would be required to store the decrypted output. Moreover, if this is not done, the routine will not reuse the input encrypted buffer by itself
&nbsp; | Java, Objective C -<li>The output is always returned as a newly allocated array/buffer (```byte[]``` in Java, ```NSMutableData **``` in Objective C)

<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, the API-Client should use the default CipherSpec/Salt so that service provider can make use of the encrypted data (remember?)
</aside>

## HTTP Requests/Responses

<!--
```c
int
coreEncryptHttpRequest
(void*  pvRuntimeCtx,
 e_core_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 char*  request,
 int    requestLen,
 char** transformedRequest,
 int*   transformedRequestLen);

int
coreDecryptHttpResponse
(void*  pvRuntimeCtx,
 e_core_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 char*  transformedResponse,
 int    transformedResponseLen,
 char** response,
 int*   responseLen);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract
    RDNAStatus<String>
    encryptHttpRequest(
      RDNAPrivacyScope
             privacyScope,
      String cipherSpec,
      byte[] cipherSalt,
      String request);

  public abstract
    RDNAStatus<String>
    decryptHttpResponse(
      RDNAPrivacyScope
             privacyScope,
      String cipherSpec,
      byte[] cipherSalt,
      String transformedResponse);
  //..
}
```

```objective_c
@interface RDNA : NSObject
  - (int)encryptHttpRequest:(RDNAPrivacyScope)privacyScope
                 CipherSpec:(NSString *)cipherSpec
                 CipherSalt:(NSString *)cipherSalt
                       From:(NSString *)request
                       Into:(NSMutableString **)transformedRequest;

  - (int)decryptHttpResponse:(RDNAPrivacyScope)privacyScope
                  CipherSpec:(NSString *)cipherSpec
                  CipherSalt:(NSString *)cipherSalt
                        From:(NSString *)transformedResponse
                        Into:(NSMutableString **)response;
@end
```

```cpp
class RDNA
{
public:
  int
  encryptHttpRequest
  (RDNAPrivacyScope
               privacyScope,
   std::string cipherSpec,
   std::string cipherSalt,
   char*       request,
   int         requestLen,
   char**      transformedRequest,
   int*        transformedRequestLen);

  int
  decryptHttpResponse
  (RDNAPrivacyScope
               privacyScope,
   std::string cipherSpec,
   std::string cipherSalt,
   char*       transformedResponse,
   int         transformedResponseLen,
   char**      response,
   int*        responseLen);
}
```

Routine | Description
------- | -----------
<b>EncryptHttpRequest</b> | <li>HTTP request in plaintext (unencrypted) form is supplied as a buffer of bytes.<li>This request is encrypted using keys as per specified privacy scope, encoded appropriately, wrapped around in an HTTP request envelope and returned back to calling API-client application as another HTTP request.
&nbsp; | ANSI C, C++ -<li>If the supplied ```transformedRequest``` and ```transformedRequestLen``` are non-null, they are used to store the encrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)
&nbsp; | Java, Objective C -<li>The output is always returned as a newly allocated String (```String``` in Java, ```NSMutableString **``` in Objective C)
<b>DecryptHttpResponse</b> | <li>HTTP response in encrypted form is supplied as a buffer of bytes.<li>This response is parsed, the embedded encrypted HTTP response is decoded, decrypted using keys as per specified scope, and returned back to calling API-client application as the original plaintext HTTP response.
&nbsp; | ANSI C, C++ -<li>If the supplied ```response``` and ```responseLen``` are non-null, they are used to store the decrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)<li>Recommended method is to supply input encrypted buffer itself in these output parameters, since it will definitely be larger than or equal to what would be required to store the decrypted output. Moreover, if this is not done, the routine will not reuse the input encrypted buffer by itself
&nbsp; | Java, Objective C -<li>The output is always returned as a newly allocated String (```String``` in Java, ```NSMutableString **``` in Objective C)

<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, the API-Client should use the default CipherSpec/Salt so that service provider can make use of the encrypted data (remember?)
</aside>

## Privacy Streams

<!--
```c
typedef enum {
  RDNA_STREAM_TYPE_ENCRYPT = 0x00, /* Encrypts input data */
  RDNA_STREAM_TYPE_DECRYPT = 0x01, /* Decrypts input data */
} e_core_stream_type_t;

typedef int
(*fn_block_ready_t)
(void*  pvStream,
 void*  pvBlockReadyCtx,
 unsigned char*  pvBlockBuf,
 int    nBlockSize);

int
coreCreatePrivacyStream
(void*  pvRuntimeCtx,
 e_core_stream_type_t
        eStreamType,
 e_core_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 int    nBlockReadyThreshold,
 fn_block_ready_t cbfnBlockReady,
 void*  pvBlockReadyCtx,
 void** pvStream);

int
coreStreamGetPrivacyScope
(void*  pvStream,
 e_core_privacy_scope_t*
        pePrivScope);

int
coreStreamGetStreamType
(void*  pvStream,
 e_core_stream_type_t*
        peStreamType);

int
coreStreamWriteDataIntoStream
(void*  pvStream,
 unsigned char*  pDataBuf,
 int    nDataLen);

int
coreStreamEndStream
(void*  pvStream);

int
coreStreamDestroy
(void*  pvStream);
```
-->

```java
public abstract class RDNA {
  //..
  public enum RDNAStreamType {
    RDNA_STREAM_TYPE_ENCRYPT(0),
    RDNA_STREAM_TYPE_DECRYPT(1);
  };

  public static interface
  RDNAPrivacyStreamCallBacks {
    int
    onBlockReady
    (RDNAPrivacyStream
            rdnaPrivStream,
     Object pvBlockReadyCtx,
     byte[] pvBlockBuf,
     int    nBlockSize);
  };

  public static interface RDNAPrivacyStream {
    public RDNAStatus<RDNAPrivacyScope> getPrivacyScope();
    public RDNAStatus<RDNAStreamType> getStreamType();
    public int writeDataIntoStream (byte[] data);
    public int endStream();
    public int destroy();
  }

  public abstract
    RDNAStatus<RDNAPrivacyStream>
    createPrivacyStream
    (RDNAStreamType
            streamType,
     RDNAPrivacyScope
            privacyScope,
     String cipherSpecs,
     String cipherSalt,
     int    blockReadyThreshold,
     RDNAPrivacyStreamCallBacks
            callbacks,
     Object pvBlockReadyCtx);
  //..
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAStreamType) {
  RDNA_STREAM_TYPE_ENCRYPT = 0x00,
  RDNA_STREAM_TYPE_DECRYPT = 0x01,
};

@protocol RDNAPrivacyStreamCallBacks

  @required

  - (int)onBlockReadyFor:(RDNAPrivacyStream *)rdnaPrivStream
       BlockReadyContext:(id)pvBlockReadyCtx
      PrivacyBlockBuffer:(NSData *)pvBlockBuf
            andBlockSize:(int)nBlockSize;
@end

@interface RDNAPrivacyStream : NSObject {
    @public
    id <RDNAPrivacyStreamCallBacks> callBack;
    void *corePrivyStream;
}
  - (int)getPrivacyScope:(RDNAPrivacyScope *)privacyScope;
  - (int)getStreamType:(RDNAStreamType *)streamType;
  - (int)writeDataIntoStream:(NSData *)data;
  - (int)endStream;
  - (int)destroy;
@end

@interface RDNA : NSObject
  //..
  - (int)createPrivacyStreamFor:(RDNAStreamType)streamType
                   PrivacyScope:(RDNAPrivacyScope)privacyScope
                     CipherSpec:(NSString *)cipherSpec
                     CipherSalt:(NSString *)cipherSalt
            BlockReadyThreshold:(int)blockReadyThreshold
     RDNAPrivacyStreamCallBacks:(id<RDNAPrivacyStreamCallBacks>)callbacks
              BlockReadyContext:(id)pvBlockReadyCtx
              RDNAPrivacyStream:(RDNAPrivacyStream **)privStream;
  //..
@end
```

```cpp
typedef enum {
  RDNA_STREAM_TYPE_ENCRYPT = 0x00,   /* a stream for encrypting */
  RDNA_STREAM_TYPE_DECRYPT = 0x01,   /* a stream for decrypting */
} RDNAStreamType;

class RDNAPrivacyStreamCallBacks
{
public:
  virtual
  int
  onBlockReady
  (RDNAPrivacyStream*
          rdnaPrivStream,
   void*  pvBlockReadyCtx,
   unsigned char*
          pvBlockBuf,
   int    nBlockSize) = 0;
};

class RDNAPrivacyStream
{
public:
  int getPrivacyScope(RDNAPrivacyScope& privacyScope);
  int getStreamType(RDNAStreamType& streamType);
  int writeDataIntoStream(unsigned char* data, int dataLen);
  int endStream();
  int destroy();
};

class RDNA
{
public:
  int
  createPrivacyStream
  (RDNAStreamType
               streamType,
   RDNAPrivacyScope
               privacyScope,
   std::string cipherSpec,
   std::string cipherSalt,
   int         blockReadyThreshold,
   RDNAPrivacyStreamCallBacks*
               callbacks,
   void*       pvBlockReadyCtx,
   RDNAPrivacyStream**
               privStream);
}
```

Routine | Description
------- | -----------
<b>BlockReady Callback</b> | <li>This is a callback routine supplied by the API-client. This routine is invoked from within the ```WriteDataIntoStream``` routine, when the requisite number of blocks are ready for consumption by the API-client (i.e. when that many blocks have been encrypted/decrypted, depending on the type of the privacy stream<li>In Ansi C, this refers to ```fn_block_ready_t``` and in other languages, this refers to ```RDNAPrivacyStreamCallBacks``` which needs to be implemented by API-Client
<b>CreatePrivacyStream</b> | <li>Creates a privacy stream using the supplied input - stream type (encryption/decryption), privacy scope, cipher specifications and salt, block ready callback routine and its opaque context reference, number of blocks on which to fire the block ready callback.<li><b>Stream type</b> - whether the data written into the stream should be encrypted/decrypted<li><b>Privacy scope</b> - this determines which key will be used for the encryption/decryption of data written to the stream<li><b>Cipher specs</b> - specifications of the block encryption algorithm and associated parameters to use for encrypting/decrypting data written to the stream<li><b>Cipher salt</b> - additional salt vector to be used when creating the encryption/decryption cipher<li><b>Block ready threshold size</b> - the number of ready blocks on which to invoke the block ready callback routine. It takes a minimum of 1 and maximum of 64 blocks(default). Pass 0 to choose the default value.<li><b>Block ready callback</b> and <b>opaque context reference</b> - callback routine to invoke when specified number blocks are read (encrypted/decrypted), along with an opaque context reference to pass when invoking it<li><b>[OUT] Stream reference</b> - out parameter in which the reference to the newly created privacy stream should be updated
<b>GetPrivacyScope</b> | Routine to query and determine the privacy scope (app/device/user/session) of a previously created privacy stream reference
<b>GetStreamType</b> | Routine to query and determine the stream type (encrypt/decrypt) of a previously created privacy stream reference
<b>WriteDataIntoStream</b> | Routine to write chunks of data into a privacy stream.<br>This routines invocation could result in the invocation of the block-ready callback routine supplied during the creation of the stream.
<b>EndStream</b> | Routine to terminate/end the stream - whatever unencrypted/undecrypted data is present in the stream buffers are padded and finally encrypted/decrypted.<br>This routines invocation always results in the invocation of the block-ready callback routine supplied during the creation of the stream.
<b>StreamDestroy</b> | Routine to free up the resources used for this privacy stream.


<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, the API-Client should use the default CipherSpec/Salt so that service provider can make use of the encrypted data (remember?)
</aside>

# API - Pause-Resume

The pause and resume routines make it possible to persist the <i>in-session</i> state of the API runtime and restore the runtime from the previously persisted state.

This is useful in case of limited configuration devices and platforms - such as smartphone device platforms like Android, iOS and WindowsPhone. In these platforms, a running application could be swapped out of memory due to 'crowding' by other running applications, only to be swapped back in when the user chooses to access that application again.

<!--
```c
int
corePauseRuntime
(void*  pvRuntimeCtx,
 char** ppvState,
 int*   pnStateSize);

int
coreResumeRuntime
(void** ppvRuntimeCtx,
 char*  pvState,
 int    nStateSize,
 core_callbacks_t*
        pCallbacks,
 proxy_settings_t*
        pProxySettings,
 void*  pvAppCtx);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract RDNAStatus<byte[]> pauseRuntime();

  public static RDNAStatus<RDNA>
    resumeRuntime
    (byte[] state,
    RDNACallbacks callbacks,
    RDNAProxySettings proxySettings,  
    RDNALoggingLevel loggingLevel,
    Object appCtx);
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  - (int)pauseRuntime:(NSMutableData **)state;

  + (int)resumeRuntime:(RDNA **)ppRuntimeCtx
            SavedState:(NSData *)state
             Callbacks:(id<RDNACallbacks>)callbacks
         ProxySettings:(RDNAProxySettings *)proxySettings
     RDNALoggingLevel :(RDNALoggingLevel)loggingLevel
            AppContext:(id)appCtx;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  int
  pauseRuntime
  (std::string& state);

  static int
  resumeRuntime
  (RDNA**             ppRuntimeCtx,
   std::string        state,
   RDNACallbacks*     callbacks,
   RDNAProxySettings* proxySettings,
   void*              appCtx);
  //..
}
```

Routine | Description
------- | -----------
<b>PauseRuntime</b> | <li>State of API runtime is serialized and returned in output buffer.<li>Information in this buffer is encrypted and must be supplied <i>AS IS</i> back with the ```ResumeRuntme``` routine call.<li><b>Initiates termination/cleanup of the API-runtime before returning</b>
<b>ResumeRuntime</b> | <li>The supplied buffer containing a previously saved runtime state is used to re-initialize the runtime to that saved state. <li>The callback routines from the API-client must again be supplied herewith - these are not serialized by ```PauseRuntime``` since they are references to code blocks in memory and may not be valid across process re-invocations.<li>```StatusUpdate``` callback is invoked to signal completion of the re-initialization.

<aside class="notice"><b>It is recommended that the API-client application further encrypt this information before storing it for later retrieval and restoration into the API-runtime</b></aside>

# API - Information Getters

<!--
```c
const char*
coreGetSdkVersion
();

e_core_error_t
coreGetErrorInfo
(int errorCode);

int
coreGetSessionID
(void*  pvRuntimeCtx,
 char** ppcSessionId);

int
coreGetAgentID
(void*  pvRuntimeCtx,
 char** ppcAgentID);

int
coreGetDeviceID
(void*  pvRuntimeCtx,
 char** ppcDeviceID);
```
-->

```java
public abstract class RDNA {
  //..
  public static String getSDKVersion();
  public static RDNAErrorID getErrorInfo(int errorCode);
  public abstract RDNAStatus<String> getSessionID();
  public abstract RDNAStatus<String> getAgentID();
  public abstract RDNAStatus<String> getDeviceID();
  public abstract int getConfig(String userID);
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  + (NSString *)getSDKVersion;
  + (RDNAErrorID)getErrorInfo:(int)errorCode;
  - (int)getSessionID:(NSMutableString **)sessionID;
  - (int)getAgentID:(NSMutableString **)agentID;
  - (int)getDeviceID:(NSMutableString **)deviceID;
  - (int)getConfig:(NSString *)userID;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  static std::string getSdkVersion();
  static RDNAErrorID getErrorInfo(int errorCode);
  int getSessionID(std::string& sessionID);
  int getAgentID(std::string& agentID);
  int getDeviceID(std::string& deviceID);
  int getConfig(std::string configRequest);
  //..
}
```

Routine | Description
------- | -----------
<b>GetSdkVersion</b> | Get the API-SDK version number
<b>GetErrorInfo</b> | Get the error information corresponding to an integer error code returned by any API. It returns back ```RDNAErrorID``` which gives brief information of the error occured
<b>GetSessionID</b> | Get the session ID of the current initialized REL-ID session. Depending on the current state of the API-Runtime, the retrieved session ID will be either of the current application (PRIMARY) REL-ID session or of the current user (SECONDARY) REL-ID session.
<b>GetAgentID</b> | Get the Agent ID using which the REL-ID session is initialized
<b>GetDeviceID</b> | Get the device ID of the current device using which the REL-ID session is initialized
<b>GetConfig</b> | Get the configuration data from the server. No assumption is made with regards to the structure or format of the configuration data, except that it should be an ASCII string. The parameter ```configRequest``` is a hint to the server to provide a subset of the config based on the value of ```configRequest```.

# API - User authentication

REL-ID APISDK provides a set of API for authenticating an end-user. The API builds on top of the application (PRIMARY) REL-ID session, perform end-user authentication, and further associate a mutually authenticated end-user to form the user (SECONDARY) REL-ID session.<br><br>The client-server interaction to transition the user from the application (PRIMARY) REL-ID session to the user (SECONDARY) REL-ID session is through the challenge-response mechanism. The server would present a initial set of challenges and when the API-client responds to these challenges, the server would either mark the client to have been authenticated, or would present the next set of challenges. After the server has successfully verified the responses to the challenges, it would create a (SECONDARY) REL-ID session, which is based on the user REL-ID (which is unique to that user).
<br><br>Subsequently all the communication channels will be secured using the ```user REL-ID```.

<aside class="notice">Note that all of the Advanced API routines may only be invoked once the Basic Initialization is successfully completed. This is because the primary function of the Advanced API is to perform end-user authentication on a previously established, valid 'PRIMARY' session</aside>

<aside class="notice">These APIs are designed to allow complete flexibility to the API-client application to be able to specify/conduct its own method of user-authentication. <i><u>While the built-in behavior for these API routines in the REL-ID API-SDK and backend is specific albeit configurable, this behavior can be customized to the needs of the enterprise application</u></i>.</aside>

## CheckChallengeResponse

```java
public abstract class RDNA {
  //..
  public abstract int checkChallengeResponse(RDNAChallenge[] challenges,String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)checkChallengeResponse:(NSArray *)challenges forUserID:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int checkChallengeResponse(vector<RDNAChallenge> challenges, std::string userID);
}
```

As part of the API call sequence to authenticate an end-user, the API-client receives challenges in the form of RDNAChallenge objects/structs. The API-client would then receive the response to the challenge from the end-user, and use the ```checkChallengeResponse``` API to pass the challenge responses to the server. The response will be validated by the server. The server would then process the response and the API-client will receive a ```RDNAStatusCheckChallengeResponse``` object representing the result of processing the response for the challenge. The server response would indicate that whether the response was validate successfully or not.

<aside class="notice">This API should only be called to authenticate an end-user, and post authentication this API should not be used. Please refer to <u><i>getPostLoginChallenges</i></u> API for getting the end-user to authenticate, post successful authentication in the same session</aside>

## UpdateChallenges

```java
public abstract class RDNA {
  //..
  public abstract int updateChallenges(RDNAChallenge[] challenges,String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)updateChallenges:(NSArray *)challenges forUserID:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int updateChallenges(vector<RDNAChallenge> challenges, std::string userID);
}
```

## LogOff

```java
public abstract class RDNA {
  //..
  public abstract int logOff(String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)logOff:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int logOff(std::string userID);
}
```


## GetAllChallenges

```java
public abstract class RDNA {
  //..
  public abstract int getAllChallenges(String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)getAllChallenges:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int getAllChallenges(std::string userID);
}
```

## ResetChallenge

```java
public abstract class RDNA {
  //..
  public abstract int resetChallenge();
}
```

```objective_c
@interface RDNA
  //...
  - (int)resetChallenge;
@end
```

```cpp
class RDNA {
  //...
  int resetChallenge();
}
```

## GetPostLoginChallenges

```java
public abstract class RDNA {
  //..
  public abstract int getPostLoginChallenges(String userID, String useCaseName);
}
```

```objective_c
@interface RDNA
  //...
  - (int)getPostLoginChallenges:(NSString *)userID withUseCaseName:(NSString *)useCaseName;
@end
```

```cpp
class RDNA {
  //...
  int getPostLoginChallenges(std::string userID, std::string useCaseName);
}
```


# API - Device Management

## RDNADeviceDetails

```java
public abstract class RDNA {
	//..
  public abstract static class RDNADeviceDetails{
    protected String deviceUUID;
    protected String deviceName;
    protected final RDNADeviceBinding deviceBinding;
    protected RDNADeviceStatus deviceStatus;
    protected final String deviceRegistrationTime;
    protected final String lastAccessTime;
    protected final String lastLoginStatus;

    public abstract void setNewDeviceName(String newDeviceName);
    public abstract void deleteDevice();
    public abstract RDNADeviceStatus getDeviceStatus();
    public abstract String getDeviceUUID();
    public abstract String getDeviceName();
    public abstract RDNADeviceBinding getDeviceBinding();
    public abstract String getDeviceRegistrationTime();
    public abstract String getLastAccessTime();
    public abstract String getLastLoginStatus();
  }
}
```

```objective_c
@interface RDNADeviceDetails : NSObject

    @property (nonatomic, readonly, copy) NSString *deviceUUID;
    @property (nonatomic, copy) NSString *deviceName;
    @property (nonatomic, readonly) RDNADeviceBinding deviceBinding;
    @property (nonatomic, readonly) RDNADeviceStatus deviceStatus;
    @property (nonatomic, readonly, copy) NSString *deviceRegistrationTime;
    @property (nonatomic, readonly, copy) NSString *lastAccessTime;
    @property (nonatomic, readonly, copy) NSString *lastLoginStatus;

    - (void)deleteDevice;                                                  
    - (void)setDeviceName:(NSString *)deviceName;                          

@end
```

```cpp
class RDNADeviceDetails {

private:
  RDNADeviceBinding deviceBinding;
  RDNADeviceStatus deviceStatus;
  std::string deviceName;
  std::string lastAccessTime;
  std::string deviceRegistrationTime;
  std::string deviceUUID;
  std::string lastLoginStatus;

  RDNADeviceDetails(RDNADeviceBinding devBinding, RDNADeviceStatus devStatus, std::string devName,
    std::string lastAccessTimeStamp, std::string devRegistrationTime, std::string devUUID, std::string lastLoginStatus)
    :deviceBinding(devBinding),
    deviceStatus(devStatus),
    deviceName(devName),
    lastAccessTime(lastAccessTimeStamp),
    deviceRegistrationTime(devRegistrationTime),
    deviceUUID(devUUID),
    lastLoginStatus(lastLoginStatus)
  {
  }

  friend class RDNA;
public:
  inline RDNADeviceBinding getDeviceBinding() { return deviceBinding; }
  inline RDNADeviceStatus getDeviceStatus() { return deviceStatus; }
  inline std::string getLastAccessTime() { return lastAccessTime; }
  inline std::string getDeviceRegisterTime() { return deviceRegistrationTime; }
  inline std::string getLastLoginStatusDevice() { return lastLoginStatus; }
  inline std::string getDeviceName() { return deviceName; }
  inline std::string getDeviceUUID() { return deviceUUID; }

  inline void setNewDeviceName(std::string newDeviceName) { deviceName = newDeviceName; deviceStatus = RDNA_DEVSTATUS_UPDATE;}
  inline void deleteDevice() { deviceStatus = RDNA_DEVSTATUS_DELETE; }
};
```

The RDNADeviceDetails class provides the information of a device, this is to provide the feature of device management to the user. Object of this class defines a single device information such as device name, device registration time stamp etc.

Member | Description
------ | -----------
<b>deviceBinding</b> | This is a enum representation of device-binding of device. There are two binding states temporary or permanent
<b>deviceStatus</b> | This is the enum representation of device status, for all binded devices the status would be the active, user can only have the option to delete the device.
<b>deviceName</b> | This is string representation of the device name, a default devie name can be set by the RelID-core and even an option can be given to the user to set the specific name for a device.
<b>lastAccessTime</b> | This is the string representation of the time stamp, when the device was accessed last time.
<b>deviceRegistrationTime</b> | This is the string representation of the time stamp when the device was registred first time with the RelID-core
<b>deviceUUID</b> | This is the string representation of the device unique identifier. This is for internal use only by the RelID-core.
<b>lastLoginStatus</b> | This is the string representation of the status of login whether last login from this device was success or failed.


Method | Description
------ | -----------
<b>deleteDevice</b> | This will mark the device for deletion from the server's list of registered devices for the user.
<b>setNewDeviceName</b> | This will rename the device.

<aside class="notice">Any changes made the device details through the above described methods will only be reflected in the server, after the ```UpdateDeviceDetails``` API has been invoked with the updated device details. Until then, all changes made will be local and will not be persistent.</aside>

## UpdateDeviceDetails

```java
public abstract class RDNA {
  //..
  public abstract int updateDeviceDetails(String userID,RDNADeviceDetails[] devices);
}
```

```objective_c
@interface RDNA
  //...
  - (int)updateDeviceDetails:(NSString *)userID withDevices:(NSArray *)devices;
@end
```

```cpp
class RDNA {
  //...
  int updateDeviceDetails(std::string userID, vector<RDNADeviceDetails> devices);
}
```

UpdateDeviceDetails API is to be used by the API-client to persist any changes made to the list of list of registered devices for that user.

Parameter | Description
--------- | -----------
<b>userID</b> | The username or userID of the user, for whom the device details need to be updated.
<b>devices</b> | The list of ```RDNADeviceDetails``` objects/structs. Any changes made to the details through the ```RDNADeviceDetails``` provided methods will only be reflected in the server upon the successful execution of this API method.

## GetRegisteredDeviceDetails

This API fetches the list of devices registered to the user whose userID/username is provided as input parameter.

```java
public abstract class RDNA {
  //..
  public abstract int getRegisteredDeviceDetails(String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)getRegisteredDeviceDetails:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int getRegisteredDeviceDetails(std::string userID);
}
```

# API - Notification Management

## RDNANotification

```java
public abstract class RDNA {

    public static class RDNAExpectedResponse
    {
        public String responseLabel;
        public String response;

        RDNAExpectedResponse(String responseLabel, String response) {
            this.responseLabel=responseLabel;
            this.response=response;
        }
    };

    //..
    public static class RDNANotification {
       public String notificationID;
       public String subject;
       public String notificationMessage;
       public String notificationResponse;
       public String notificationExpireTime;
       public String enterpriseID;
       public RDNAExpectedResponse[] expectedResponse;

       RDNANotification(String notificationID,
                        String subject,
                        String notificationMessage,
                        String notificationExpireTime,
                        String enterpriseID,
                        RDNAExpectedResponse[] expectedResponse)
       {
           this.notificationID = notificationID;
           this.subject = subject;
           this.notificationMessage = notificationMessage;
           this.notificationExpireTime = notificationExpireTime;
           this.enterpriseID = enterpriseID;
           this.expectedResponse = expectedResponse;
       }
   }
}
```

```objective_c

@interface RDNAExpectedResponse : NSObject
  @property (nonatomic,strong) NSString *responseLabel;
  @property (nonatomic,strong) NSString *response;
@end

@interface RDNANotification : NSObject
  @property (nonatomic,strong) NSString *notificationID;
  @property (nonatomic,strong) NSString *subject;
  @property (nonatomic,strong) NSString *notificationMessage;
  @property (nonatomic,strong) NSArray<RDNAExpectedResponse *>
                                                  *expectedResponse;
  @property (nonatomic,strong) NSString *notificationResponse;
  @property (nonatomic,strong) NSString *notificationExpireTime;
  @property (nonatomic,strong) NSString *enterpriseID;
@end

```

```cpp

struct RDNAExpectedResponse
{
  string responseLabel;
  string response;
};

class RDNANotification
{
public:
  string notificationID;
  string subject;
  string notificationMessage;
  string notificationResponse;
  string notificationExpiryTime;
  string enterpriseID;
  vector<RDNAExpectedResponse> expectedResponse;
};

```

The RDNANotification class provides the information of a single notification in a structured format, this is to provide the feature of Notification management to the user. Object of this class defines a notification information such as notification ID, notification message etc.

###RDNAExpectedResponse

Member | Description
------ | -----------
<b>responseLabel</b> | Label name of the action that can be performed on the notification
<b>response</b> | The actual response value of the above response label, this value has to be provided while updating the notification

###RDNANotification

Member | Description
------ | -----------
<b>notificationID</b> | This is a string representation of unique notification ID.
<b>subject</b> | This is string representation of notification subject, a message can have a subject such as the if a transaction notification then subject for the notification could be the Transaction.
<b>notificationMessage</b> | This is string representation of the actual notification message.
<b>notificationResponse</b> | This is the string representation of the response which user has provded after the notification is processed by the user. Note: Right now this not been used, this is added for future.
<b>notificationExpiryTime</b> | This is the string representation of the expiry time stamp when notifiction wil be expired.
<b>enterpriseID</b> | This is the string representation enterprise ID, this specifies that for which enterprise the notification is related to.

## GetNotifications

This API fetches the list of notifications which are active. We can get the notifications for a specific enterprise also, Even we can specify the number of records to be fetched, and even we can specify the index number from which the records to be fetched to support the paging of notification. To get all the notifications from the server we should provide the recordCount value as 0 and server send all the active Notifications of the user.

```java
public abstract class RDNA {
  //..
  public abstract int getNotifications(int recordCount,
                                       int startRecord,
                                       String enterpriseID,
                                       String startDate,
                                       String endDate);
}
```

```objective_c
@interface RDNA
  //...
  - (int)getNotifications:(int)recordCount
                          withStartIndex:(int)startIndex
                          withEnterpriseID:(NSString*)enterpriseID
                          withStartDate:(NSString*)startDate
                          withEndDate:(NSString*)endDate;

@end
```

```cpp
class RDNA {
  //...
  int getNotifications(int nRecordCount,
                       int nStartRecord,
                       string enterpriseID,
                       string startDate,
                       string endDate);
}
```

## UpdateNotification

This API is to update the notification response selected by the user. We can update the only one notification at a time, to update the multiple notifications application has to call this API multiple times.

```java
public abstract class RDNA {
  //..
  public abstract int updateNotifications(String notificationID,
                                          String response);
}
```

```objective_c
@interface RDNA
  //...
  - (int)updateNotification:(NSString*)notificationID
                             withResponse:(NSString*)response;

@end
```

```cpp
class RDNA {
  //...
  int updateNotification(string notificationID,
                         string response)
}
```

# API - Notification History

## RDNANotificationHistory

The RDNANotificationHistory class provides history of a single notification in a structured format. Object of this class defines a notification information such as notification ID, action taken, notification message etc. A list of RDNANotificationHistory objects is returned as a part of query statement provided in the API - ```GetNotificationsHistory```.

###RDNANotification

```java
public static class RDNANotificationHistory {
    public String notificationID;   
    public String deliveryStatus;   
    public String status;           
    public String subject;          
    public String message;          
    public String actionPerformed;  
    public String deviceUUID;       
    public String deviceName;     
    public String createdTime;    
    public String updatedTime;      
    public String expiredTime;    
    public String enterpriseID;     
}
```

```objective_c
@interface RDNANotificationHistory : NSObject

  @property (nonatomic,strong) NSString *notificationID;  
  @property (nonatomic,strong) NSString *deliveryStatus;  
  @property (nonatomic,strong) NSString *status;          
  @property (nonatomic,strong) NSString *subject;         
  @property (nonatomic,strong) NSString *message;         
  @property (nonatomic,strong) NSString *actionPerformed;
  @property (nonatomic,strong) NSString *deviceUUID;      
  @property (nonatomic,strong) NSString *deviceName;      
  @property (nonatomic,strong) NSString *createdTime;     
  @property (nonatomic,strong) NSString *updatedTime;     
  @property (nonatomic,strong) NSString *expiredTime;     
  @property (nonatomic,strong) NSString *enterpriseID;    

@end
```

```cpp
class RDNANotificationHistory
{
public:
  string notificationID;  //Unique ID for notifications
  string status;          //<ACTIVE / EXPIRED / UPDATED>
  string subject;         //Subject of the notification
  string message;         //Notification Text to be displayed to user
  string actionTaken;     //Notification action taken by user
  string deviceName;      //Notification action taken on specific device
  string createdTime;     //Notification generated time on server
  string updatedTime;     //Notification action taken by user time
  string expiredTime;     //Notification expired time
  string enterpriseID;    //Enterprise ID which we have got while onboarding the enterprise application
};
```

Member | Description
------ | -----------
<b>notificationID</b> | This is a string representation of unique notification ID.
<b>deliveryStatus</b> | This specifies if the client has been notified about the notification. The values can be NOTIFIED / PARTIALLY_NOTIFIED / FAILED_TO_NOTIFY.
<b>status</b> | This represents the status of the notification. It can have values as ACTIVE / EXPIRED / UPDATED.
<b>subject</b> | This is string representation of notification subject. If a message is a transaction notification then subject for the notification could be Transaction.
<b>message</b> | This is string representation of the actual notification message.
<b>actionTaken</b> | This is string representation of the action taken by the user on the notification.
<b>deviceName</b> | This is string representation of the device on which an action was performed by the user for the said notification.
<b>createdTime</b> | This specifies the notification generated time on server.
<b>updatedTime</b> | This specifies the time when the user performed an action on the notification
<b>expiredTime</b> | This specifies the expiry time of the notification.
<b>enterpriseID</b> | This is the string representation enterprise ID, this specifies that for which enterprise the notification is related to.

## GetNotificationsHistory

<!--
```c
int coreGetNotificationHistory
 (void* pvRuntimeCtx,
  int nRecordCount,
  char* pcEnterpriseID,
  int nStartRecord,
  char* pcStartDate,
  char* pcEndDate,
  char* pcStatus,
  char* pcAction,
  char* pcKeyword,
  char* pcDevUUID);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract int getNotificationHistory
        (int recordCount,
         String enterpriseID,
         int startIndex,
         String startDate,
         String endDate,
         String notificationStatus,
         String actionPerformed,
         String keywordSearch,
         String deviceID);

}
```

```objective_c
@interface RDNA
  //...
  - (int)getNotificationHistory:(int)recordCount
                 withStartIndex:(int)startIndex
               withEnterpriseID:(NSString*)enterpriseID
                  withStartDate:(NSString*)startDate
                    withEndDate:(NSString*)endDate
         withNotificationStatus:(NSString*)notificationStatus
            withActionPerformed:(NSString*)actionPerformed
              withKeywordSearch:(NSString*)keywordSearch
                   withDeviceID:(NSString*)deviceID;

@end
```

```cpp
class RDNA {
  //...
  int getNotificationHistory
   (int nRecordCount,
    string pcEnterpriseID,
    int nStartRecord,
    string pcStartDate,
    string pcEndDate,
    string pcStatus,
    string pcAction,
    string pcKeyword,
    string pcDevUUID);
}
```

This API is used to fetch the notification history for a particular user. The fetch request can be optimized by various filters to get the very necessary data only. ```The history will not contain active notifications.```

# API - HTTP Tunnel (Rest) connection

The CORE SDK has the facility to provide secure access to any resource via the Rel-ID authenticated channel using HTTP, HTTPs and Port forwarding proxies. In addition to this proxies, there came a need to add an API which can handle similar such request but limited to a single request response (Similar to RESTful web services).

## Structures

HTTP tunnel connection api uses ```RDNAHTTPRequest``` to issue a request and gets a response from the SDK in the ```RDNAHTTPResponse``` structure. The SDK wraps the ```RDNAHTTPRequest``` and ```RDNAHTTPResponse``` together into ```RDNAHttpStatus``` as a part of the response.

The requestID in the RDNAHttpStatus is a unique integer value to identify the RDNAHTTPRequest. The requestID is issued to the application as a part of the ```openHttpConnection``` api.

```cpp
typedef enum {
  RDNA_HTTP_POST = 0,
  RDNA_HTTP_GET,
}RDNAHttpMethods;

typedef struct RDNAHTTPRequest_s {
  RDNAHttpMethods Method;
  string URL;
  std::map<string, string> Headers;
  string Body;
  RDNAHTTPRequest_s() : Method(RDNA_HTTP_GET), URL(""), Body("")
  {}
}RDNAHTTPRequest;

typedef struct RDNAHTTPResponse_s{
  string Version;
  int StatusCode;
  string StatusMessage;
  std::map<string, string> Headers;
  string Body;
}RDNAHTTPResponse;

typedef struct RDNAHttpStatus_s{
  int errorCode;
  int requestID;
  RDNAHTTPRequest* request;
  RDNAHTTPResponse* response;
}RDNAHttpStatus;
```

```java
public static enum RDNAHTTPMethods{
	RDNA_HTTP_POST(0),
	RDNA_HTTP_GET(1);
}

public static class RDNAHTTPRequest{
	public RDNAHTTPMethods method;
	public String url;
	public HashMap<String,String> headers;
	public byte[] body;
}

public static class RDNAHTTPResponse{
	public String version;
	public int statusCode;
	public String statusMessage;
	public HashMap<String,String> headers;
	public byte[] body;
}

public static class RDNAHTTPStatus{
	public int errorCode;
	public int requestID;
	public RDNAHTTPRequest request;
	public RDNAHTTPResponse response;
}
```

```objective_c
typedef NS_ENUM(NSInteger,RDNAHttpMethods) {
 RDNA_HTTP_POST = 0,
 RDNA_HTTP_GET,
};

@interface RDNAHTTPRequest : NSObject
  @property (nonatomic,assign) RDNAHttpMethods method;
  @property (nonatomic,strong) NSString* url;
  @property (nonatomic,strong) NSDictionary* headers;
  @property (nonatomic,strong) NSData* body;
@end

@interface RDNAHTTPResponse : NSObject
  @property (nonatomic,readonly) NSString* version;
  @property (nonatomic,assign) int statusCode;
  @property (nonatomic,strong) NSString* statusMessage;
  @property (nonatomic,strong) NSDictionary* headers;
  @property (nonatomic,strong) NSData* body;
@end

@interface RDNAHTTPStatus : NSObject
  @property (nonatomic,assign) int errorCode;
  @property (nonatomic,assign) int requestID;
  @property (nonatomic,strong) RDNAHTTPRequest* request;
  @property (nonatomic,strong) RDNAHTTPResponse* response;
@end
```

<br>
<b>RDNAHttpMethods</b>

Enumeration | Description
----------- | -----------
<b>RDNA_HTTP_POST</b> | HTTP Post method
<b>RDNA_HTTP_GET</b> | HTTP Get method

<br>
<b>RDNAHTTPRequest</b>

Members | Description
------- | -----------
<b>Method</b> | HTTP method
<b>StatusCode</b> | URL whose web resource is to be fetched
<b>Headers</b> | List of request headers
<b>Body</b> | HTTP request body

<br>
<b>RDNAHTTPResponse</b>

Members | Description
------- | -----------
<b>Version</b> | HTTP version
<b>StatusCode</b> | HTTP status code
<b>StatusMessage</b> | HTTP status message
<b>Headers</b> | List of response headers
<b>Body</b> | HTTP response body

<br>
<b>RDNAHttpStatus</b>

Members | Description
------- | -----------
<b>errorCode</b> | SDK error code
<b>requestID</b> | Unique integer to identify the RDNAHTTPRequest
<b>request</b> | Object of type RDNAHTTPRequest
<b>response</b> | Object of type RDNAHTTPResponse

## Callbacks

The callback will be invoked as part of the open http connection api for the provided tunnel request id. The SDK return RDNAHTTPStatus object which contains error id, tunnel request id, RDNAHTTPRequest and RDNAHTTPResponse.

```cpp
typedef int(*onHttpResponse)(RDNAHttpStatus* status);
```

```java
public static interface RDNAHTTPCallbacks{
	int onHttpResponse(RDNAHTTPStatus status);
}
```

```objective_c
@protocol RDNAHTTPCallbacks
  @required
    -(int)onHttpResponse:(RDNAHTTPStatus*) status;
@end
```

## OpenHttpConnection

<!--
```c
 int coreOpenHttpConnection
   (void* pvRuntimeCtx,
    void* pvAppCtx,
    e_core_http_methods eMethod,
    unsigned char* pcURL,
    core_http_header** pcHeaders,
    unsigned int nHeaderLen,
    unsigned char* pcBody,
    unsigned int nBodyLen,
    int* nTunnelRequestID);
```
-->

```java
public abstract class RDNA {
  //..
  public abstract
  RDNAStatus<Integer>
  openHttpConnection
  (RDNAHTTPRequest request,
   RDNAHTTPCallbacks callback);

```

```objective_c
@interface RDNA
  //...
  -(int)openHttpConnection:(RDNAHTTPRequest*)request
                 Callbacks:(id<RDNAHTTPCallbacks>)callbacks
             httpRequestID:(int*)httpRequestID;
@end
```

```cpp
class RDNA {
  //...
  int openHttpConnection
   (RDNAHTTPRequest* aHttpReq,
    onHttpResponse respHandler,
    int& nTunnelRequestID);
```

The API tunnels HTTP request data on a Rel-ID authenticated channel. This api can be used post session creation for light weight http calls via Rel-ID authenticated channels. The application needs to register a callback method each time it invokes the api. This makes it very easy for the application developer to handle http response for http request made using the api in a different manner.

In case of java SDK, the tunnel request ID is provided as a part of return value, and for other SDK it is provided as part of out parameter.
