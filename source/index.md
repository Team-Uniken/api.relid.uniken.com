---
title: REL-ID SDK

language_tabs:
  - java: Java
  - objective_c: Objective C
  - cpp: C++
  - c: ANSI C

toc_footers:
  - <a href='http://www.uniken.com'>Uniken Website</a>

<!--includes:
  - errors-->

search: true
---

# Introduction2
<aside class="notice"><b><u>Disclaimer</u></b> -
<br>
This specification is a <u>working pre-release draft</u>.
<br>
Last updated on <u>Thursday, 12th May 2016, at 1330 IST</u>
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

<u>Relative Identity</u> (or <u>REL-ID</u> for short) is a mutual identity that encapsulates/represents uniquely, the relationship between 2 parties/entities. This mutual identity is mathematically split in two, and one part each is distributed securely to the communicating parties. The identity of each end-point party/entity is thus relative to the identity of the other end-point party/entity. REL-ID can be used to represent the relationship between user and app, user and user, or app and other app, thus providing a holistic digital identity model

The protocol handshake that authenticates the REL-ID between 2 parties/entities is RMAK which is short form for <b><u>R</u>EL-ID <u>M</u>utual <u>A</u>uthentication and <u>K</u>ey-exchange</b>. It is a unique and patented protocol handshake that enables MITM-resistant, true mutual authentication. As specified in the name, key-exchange is a by-product of a successful RMAK handshake and the exchanged keys are used for downstream privacy of communications over the authenticated channel.

<aside class="notice"><i><b><u>Agent REL-ID</u></b> and <b><u>User REL-ID</u></b></i> -
<li>An <u><b>Agent REL-ID</b></u> is used to represent the relationship between software application and the REL-ID platform backend.
<li>An <u><b>User REL-ID</b></u> is used to represent the relationship between end-user of the application and the REL-ID platform backend.
<br>
<i>Note that the REL-ID platform backend represents the enterprise.</i>
</aside>

## Device fingerprinting and binding

Every end-point computing device has a number of unique identities associated with it. This includes hardware OEM identities, as well as software identities at both OS platform and application software level. The end-point device's fingerprint is created by collecting these various identities, and using them together to uniquely identify it. 

The REL-ID platform's multi-factor authentication (MFA) is implemented by binding the devices fingerprint/identity with the REL-ID of the user/app, thus ensuring that REL-ID-based access is provided only from whitelisted end-point devices (those with identities/fingerprints bound to the relevant REL-IDs).

## Access to backend enterprise services

After successful mutual authentication between REL-ID API client-side and REL-ID platform backend (the REL-ID <b>Authentication Gateway</b>), the <b>REL-ID Digital Network Adapter</b> (or <b>RDNA</b> for short) is setup inside the API runtime for enabling secure communications of the API-client application with its enterprise backend services. These services are hidden behind the REL-ID <b>Access Gateway(s)</b> and are accessible ONLY via the RDNA, which possesses the capability to tunnel/relay/patch through application traffic between the client app and its backend services via an Access Gateway.

The backend coordinates of the enterprise services that are accessible for a given software agent REL-ID or user REL-ID are configured into the REL-ID platform on the REL-ID <b>Gateway Manager</b> console. During this configuration, these coordinates are supplied in the form that they are reachable from the REL-ID Access Gateway(s), i.e. using the internally accessible coordinates (IP addresses and port numbers).

The RDNA provides multiple mechanisms to enable this tunneling of traffic - a HTTP proxy facade, and any number of forwarded TCP ports corresponding to backend enterprise service TCP coordinates.


Facade | Description
------ | -----------
HTTP&nbsp;Proxy | The API-client uses a standard HTTP library to make its HTTP requests, instructing the library to to make the request via the specified HTTP proxy running on local loopback adapter (127.0.0.1/::1)
Forwarded&nbsp;Port | The API client connects directly to a locally present port which represents the backend enterprise service coordinate

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

The API is written with non-blocking interactions in mind - none of the API routines will block for any kind of network I/O.

When an API routine requires to perform network I/O with backend services in order to service the API-client, that I/O is delegated to the DNA which is part of the API runtime, and the results are communicated back via callback routines supplied by the API-client. The DNA itself uses non-blocking I/O for all the network communication it performs. 

 * Each API routine returns immediately without blocking on any network I/O
 * Where applicable, API call results are communicated asynchronously via API-client supplied callback routines

# Getting started

The following table lists and briefly describes the different interactions with the REL-ID API:

Interaction | Description
----------- | -----------
<u>Initialization</u> | Initialize the API runtime by establishing a REL-ID session and setting up the API runtime, including a DNA instance
<u>User&nbsp;Identity</u> | Take the REL-ID session established during <u>Initialization</u> and take it through a bunch of states via this bunch of API routines, to the final SECONDARY (user REL-ID authenticated) state.
<u>Access</u> | Provide the API-client application with connectivity to its backend enterprise services via the DNA in the API runtime - to those backend services the REL-ID session has access to.
<u>Data&nbsp;Privacy</u> | Provide the API-client application with routines to encrypt and decrypt data, with keys at different scopes, without worrying about key-management.
<u>Pause&nbsp;Resume</u> | Save API runtime state and shutdown runtime - subsequently restore runtime state and re-initialize the runtime
<u>Terminate</u> | Clean shutdown of the API runtime

<aside class="notice"><i>The <b><u>User-Identity</u></b> interaction</i> -
<br>
is applicable only when an API-client application uses the REL-ID API for the purpose of its user identity as well. This part of the API is called the REL-ID Advanced API. The rest of the interactions are applicable regardless (i.e. part of the Basic API). In other words, the Advanced API is nothing but the Basic API + User-Identity interaction.
</aside>

## Initialization

This interaction is governed by a single API routine (```Initialize```) invocation that sets the stage for all subsequent interactions. 

Most importantly, this is the phase when the <u>API runtime establishes an agent-authenticated session with the REL-ID platform</u> backend and <u>bootstraps the DNA for subsequent connectivity with both REL-ID platform services as well as the configured backend enterprise services</u>

The following information is supplied by the API-client application to the initialization routine:

 * Agent information (available as a base64-encoded blob, upon provisioning a new agent REL-ID on a commercially licensed REL-ID Gateway Manager)
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

This structure is supplied to the Initialize routing containing API-client application callback routines. These callback routines are invoked by the API runtime at different points in its execution - for updating status, for requesting the API-client application to supply information etc.

There are 3 primary callback routines that are provided - 2 of them are part of the Basic API and 1 of them is part of the Advanced API.

```c
/* Invoked by core API runtime to update API-client
   of state changes, exceptions and notifications */
typedef
int 
(*fn_status_update_t)
(core_status_t* pStatus);

/* struct of callback pointers */
typedef struct {
  fn_status_update_t pfnStatusUpdate;
  fn_get_device_fingerprint_t
                     pfnGetDeviceFingerprint;
} core_callbacks_t;
```

```java
public abstract class RDNA {
  //...
  public interface RDNACallbacks {
    public int onInitializeCompleted(RDNAStatusInit status);
    public int onTerminate(RDNAStatusTerminate status);
    public int onPauseRuntime(RDNAStatusPause status);
    public int onResumeRuntime(RDNAStatusResume status);
    public int onCheckChallengeResponseStatus(RDNAStatusCheckChallenge status);
    public int onLogOff(RDNAStatusLogOff status);
	public int onForgotPasswordStatus(RDNAStatusForgotPassword status);
	public int onUpdateChallengeStatus(RDNAStatusUpdateChallenge status);
	public int onGetPostLoginChallenges(RDNAStatusGetPostLoginChallenges status);
	public int onGetRegistredDeviceDetails(RDNAStatusGetRegisteredDeviceDetails status);
	public int onUpdateDeviceDetails(RDNAStatusUpdateDeviceDetails status);
	
    public Object getDeviceContext();
    public String getApplicationName();		
    public String getApplicationVersion();
	public RDNAIWACreds getCredentials(String domainUrl);
	//...
  }
  //..
}
```

```objective_c
@protocol RDNACallbacks
  @required
  - (int)onInitializeCompleted:(RDNAStatusInit *)status;
  - (CLLocationManager *)getLocationManager;
  - (NSString *)getApplicationVersion;
  - (NSString *)getApplicationName;
  //...

  @optional
  - (int)onTerminate:(RDNAStatusTerminate *)status;
  - (int)onPauseRuntime:(RDNAStatusPauseRuntime *)status;
  - (int)onResumeRuntime:(RDNAStatusResumeRuntime *)status;
  - (int)onLogOff:(RDNAStatusLogOff *)status;
  - (int)onCheckChallengeResponseStatus:(RDNAStatusCheckChallengesResponse *) status;
  - (int)onGetAllChallengeStatus:(RDNAStatusGetAllChallenges *) status;
  - (int)onUpdateChallengeStatus:(RDNAStatusUpdateChallenge *) status;
  - (int)onForgotPasswordStatus:(RDNAStatusForgotPassword *)status;
  - (int)onLogOff: (RDNAStatusLogOff *)status;
  - (int)onGetPostLoginAuthenticationResponseStatus:(RDNAStatusGetPostChallengeResponse *)status;
  - (int)onGetRegistredDeviceDetails:(RDNAStatusGetRegisteredDeviceDetails *)status;
  - (int)onUpdateDeviceDetails:(RDNAStatusUpdateDeviceDetails *)status;  
  - (RDAIWACreds *)getCredentials:(NSString *)domainUrl;
  //...
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
  virtual int onCheckChallengeResponseStatus(RDNAStatusCheckChallengeResponse status);
  virtual int onGetAllChallengeStatus(RDNAStatusGetAllChallenges status);
  virtual int onUpdateChallengeStatus(RDNAStatusUpdateChallenges status);
  virtual int onForgotPasswordStatus(RDNAStatusForgotPassword status);
  virtual int onLogOff(RDNAStatusLogOff status);
  virtual int onGetPostLoginChallenges(RDNAStatusGetPostLoginChallenges status);
  virtual int onGetRegistredDeviceDetails(RDNAStatusGetRegisteredDeviceDetails status);
  virtual int onUpdateDeviceDetails(RDNAStatusUpdateDeviceDetails status);  
  
  virtual std::string getApplicationName();
  virtual std::string getApplicationVersion();
  virtual RDNAIWACreds getCredentials(std::string domainUrl);
};
```

Callback Routine | Description
---------------- | -----------
<b>Status Object and variants</b> | Invoked by the API runtime in order to update the API-client application of the progress of a previously invoked API routine, or state changes and exceptions encountered in general during the course of its execution.
<b>GetDeviceContext</b> | Invoked by the API runtime during initialization (session creation) on Android (Java) in order to retrieve the device context reference to be able to determine the fingerprint identity of the end-point device.<br><br>The API-client must return the Android <u>ApplicationContext</u> of the application from this method's implementation.<br><b><u>This callback routine is specific to Android platform</u></b> 
<b>getLocationManager</b> | Invoked by the API runtime during initialization for the purpose of computing the location attributes of the device.<br><b><u>This callback routine is specific to iOS platform</u></b>
<b>getApplicationName</b> | Invoked by the API runtime when the runtime needs to retrieve the application name. The application name is used for blacklisting or whitelisting an application.
<b>getApplicationVersion</b> | This is the callback invoked when the runtime needs to retrieve the application version. The application version is used for blacklisting or whitelisting an application.
<b>getCredentials</b> | This is the callback invoked by the DNA, when it needs the HTTP authentication credentials for accessing a webpage. The parameter domainURL is of the form <<u>HNIP</u>:<u>Port</u>>, where HNIP represent the Hostname or IP address where the webpage is hosted, and the Port represents to the port number to which the connection is being made. The callaback implementation is expected to return an ```RDNAIWACreds``` object containing the relevant credentials. 

Apart from the above callback routines, specific events have been called out as onThisHappened() and onThatHappened() callbacks, in the wrapper APIs. This is to make it simpler and clearer for the API-client to react to these events.

## Proxy settings (structure)

This structure is supplied to the Initialize routine when the REL-ID Auth Gateway is accessible only from behind an HTTP proxy. For example, when using a REL-ID-integrated application from a device, when connected to a corporate intranet, where connectivity to internet is only via the corporate proxy.

Hence this structure is an optional input parameter to Initialize, and may not always require to be supplied. The API-client application requires to keep track of whether or not this needs to be supplied during initialization - for example by providing a 'connect profile settings' screen for the end-user.

At an abstract level, the pieces of information supplied by this data structure are:

```c
typedef struct {
  char* sProxyHNIP;
  int   nProxyPort;
  char* sUsername;
  char* sPassword;
} proxy_settings_t;
```

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
} RDNAProxySettings;
```

Field | Description
----- | -----------
<b>ProxyHNIP</b> | <b>H</b>ost<b>N</b>ame or <b>IP</b> address of the proxy server
<b>ProxyPort</b> | Port number of the proxy server
<b>ProxyUsername</b> | The username to use to authenticate with the proxy server. This is required only when the proxy server requires authentication.
<b>ProxyPassword</b> | The password to use with the username, to authenticate with the proxy server. This too is required only when the proxy server requires authentication.

## Status update (structures)

This structure is supplied to the API-client supplied ```StatusUpdate``` callback routine when it is invoked from the API runtime. This structure covers all possible statuses that the API runtime would notify the API-client application about.

At an abstract level, the pieces of information supplied by this data structure are:

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
  }
  
  public static class RDNAStatusCheckChallengesResponse {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallengeStatus status;
    public RDNAChallenge[] challenges;
    public RDNAService services[];
    public RDNAPort pxyDetails;
  }

  public static class RDNAStatusUpdateChallenge {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallenge[] challenges;
    public RDNAChallengeStatus status;
  }

  public static class RDNAStatusGetAllChallenges {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallenge[] challenges;
    public RDNAChallengeStatus status;
  }

  public static class RDNAStatusLogOff {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAService services[];
    public RDNAPort pxyDetails;
  }

  public static class RDNAStatusGetPostLoginChallenges{
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallengeStatus status;
    public RDNAChallenge[] challenges;
  }
  
  public static class RDNAStatusGetRegisteredDeviceDetails {
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNADeviceDetails[] devices;
    public RDNAChallengeStatus challengeStatus;
  }

  public static class RDNAStatusUpdateDeviceDetails {	
    public Object pvtRuntimeCtx;
    public Object pvtAppCtx;
    public int errCode;
    public RDNAMethodID methodID;
    public RDNAChallengeStatus challengeStatus;
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
@end

@interface RDNAStatusCheckChallengesResponse : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusUpdateChallenge : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusGetAllChallenges : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusForgotPassword : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusLogOff : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) NSArray *services;
  @property (nonatomic) RDNAPort *pxyDetails;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *challenges;
@end

@interface RDNAStatusGetRegisteredDeviceDetails : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errorCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) NSArray *devices;
@end
 
@interface RDNAStatusUpdateDeviceDetails : NSObject 
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errorCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAChallengeStatus *status;
@end
 
@interface RDNAStatusGetPostLoginChallengeResponse : NSObject
  @property (nonatomic) void *pvtRuntimeCtx;
  @property (nonatomic) void *pvtAppCtx;
  @property (nonatomic) int errCode;
  @property (nonatomic) RDNAMethodID methodID;
  @property (nonatomic) RDNAChallengeStatus *status;
  @property (nonatomic) NSArray *postLoginChallenges;
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

typedef struct RDNAStatusCheckChallengesResponse_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  RDNAChallengeStatus status;
  vector<RDNAService> services;
  vector<RDNAChallenge> challenges;
  RDNAStatusCheckChallengesResponse_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusCheckChallengeResponse;

typedef struct RDNAStatusUpdateChallenges_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAChallengeStatus status;
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
  RDNAChallengeStatus status;
  vector<RDNAChallenge> challenges;
  RDNAStatusGetAllChallenges_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusGetAllChallenges;

typedef struct RDNAStatusForgotPassword_s{
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAChallengeStatus status;
  vector<RDNAChallenge> challenges;

  RDNAStatusForgotPassword_s () : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                                  methodID(RDNA_METH_NONE)
  {}
}RDNAStatusForgotPassword;

typedef struct RDNAStatusLogOff_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAPort pxyDetails;
  RDNAChallengeStatus status;
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
  RDNAChallengeStatus updateStatus;
  RDNAStatusUpdateDeviceDetails_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                         methodID(RDNA_METH_NONE)
  {}
} RDNAStatusUpdateDeviceDetails;

typedef struct RDNAStatusGetPostLoginChallenges_s {
  void* pvtRuntimeCtx;
  void* pvtAppCtx;
  int  errCode;
  RDNAMethodID methodID;
  RDNAChallengeStatus status;
  vector<RDNAChallenge> challenges;
  RDNAStatusGetPostLoginChallenges_s() : pvtRuntimeCtx(NULL), pvtAppCtx(NULL), errCode(0),
                       methodID(RDNA_METH_NONE)
  {}
} RDNAStatusGetPostLoginChallenges;
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

The wrapper APIs written in high level languages provide similar information of status update in more specific callbacks and structures such as RDNAStatusInit, RDNAStatusPause, etc. This is to make it simpler and clearer for the API-client to react to these events.


## HTTP Authentication related structures, interfaces, enumerations and callbacks

For supporting HTTP based authentication, we provide the following 

```c
```

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

```c
typedef enum {
  CORE_ERR_NONE = 0,

  CORE_ERR_NOT_INITIALIZED = 1,
  CORE_ERR_GENERIC_ERROR,
  CORE_ERR_INVALID_VERSION,
  CORE_ERR_INVALID_ARGS,
  CORE_ERR_INVALID_CONTEXT,

  CORE_ERR_FAILED_TO_CONNECT_VIA_PROXY = 21,
  CORE_ERR_NULL_CALLBACKS,
  CORE_ERR_INVALID_HOST,
  CORE_ERR_INVALID_PORTNUM,
  CORE_ERR_INVALID_AGENT_INFO,
  CORE_ERR_FAILED_TO_CONNECT_TO_SERVER,
  CORE_ERR_FAILED_TO_AUTHENTICATE,
  CORE_ERR_INVALID_SAVED_CONTEXT,
  CORE_ERR_INVALID_HTTP_REQUEST,
  CORE_ERR_INVALID_HTTP_RESPONSE,

  CORE_ERR_INVALID_CIPHERSPECS = 42,
  CORE_ERR_PLAINTEXT_EMPTY,
  CORE_ERR_PLAINTEXT_LENGTH_INVALID,
  CORE_ERR_CIPHERTEXT_EMPTY,
  CORE_ERR_CIPHERTEXT_LENGTH_INVALID,

  CORE_ERR_SERVICE_NOT_SUPPORTED = 61,
  CORE_ERR_INVALID_SERVICE_NAME,

  CORE_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE = 81,
  CORE_ERR_FAILED_TO_GET_STREAM_TYPE,
  CORE_ERR_FAILED_TO_WRITE_INTO_STREAM,
  CORE_ERR_FAILED_TO_END_STREAM,
  CORE_ERR_FAILED_TO_DESTROY_STREAM,
  
  CORE_ERR_FAILED_TO_INITIALIZE = 101,
  CORE_ERR_FAILED_TO_PAUSERUNTIME,
  CORE_ERR_FAILED_TO_RESUMERUNTIME,
  CORE_ERR_FAILED_TO_TERMINATE,
  CORE_ERR_FAILED_TO_GET_CIPHERSALT,
  CORE_ERR_FAILED_TO_GET_CIPHERSPECS,
  CORE_ERR_FAILED_TO_GET_AGENT_INFO,
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
} e_core_error_t;
```

```java
public abstract class RDNA {
  //...
  public enum RDNAErrorID {
    RDNA_ERR_NONE(0),
    RDNA_ERR_NOT_INITIALIZED(1),
    RDNA_ERR_GENERIC_ERROR(2),
    RDNA_ERR_INVALID_VERSION(3),
    RDNA_ERR_INVALID_ARGS(4),
    RDNA_ERR_INVALID_CONTEXT(5),
	
    RDNA_ERR_FAILED_TO_CONNECT_VIA_PROXY (21),
    RDNA_ERR_NULL_CALLBACKS(22),
    RDNA_ERR_INVALID_HOST(23),
    RDNA_ERR_INVALID_PORTNUM(24),
    RDNA_ERR_INVALID_AGENT_INFO(25),
    RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER(26),
    RDNA_ERR_FAILED_TO_AUTHENTICATE(27),
    RDNA_ERR_INVALID_SAVED_CONTEXT(28),
    RDNA_ERR_INVALID_HTTP_REQUEST(29),
    RDNA_ERR_INVALID_HTTP_RESPONSE(30),
	
    RDNA_ERR_INVALID_CIPHERSPECS(42),
    RDNA_ERR_PLAINTEXT_EMPTY(43),
    RDNA_ERR_PLAINTEXT_LENGTH_INVALID(44),
    RDNA_ERR_CIPHERTEXT_EMPTY(45),
    RDNA_ERR_CIPHERTEXT_LENGTH_INVALID(46),
	
    RDNA_ERR_SERVICE_NOT_SUPPORTED(61),
    RDNA_ERR_INVALID_SERVICE_NAME(62),
	
    RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE(81),
    RDNA_ERR_FAILED_TO_GET_STREAM_TYPE(82),
    RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM(83),
    RDNA_ERR_FAILED_TO_END_STREAM(84),
    RDNA_ERR_FAILED_TO_DESTROY_STREAM(85),
	
    RDNA_ERR_FAILED_TO_INITIALIZE(101),
    RDNA_ERR_FAILED_TO_PAUSERUNTIME(102),
    RDNA_ERR_FAILED_TO_RESUMERUNTIME(103),
    RDNA_ERR_FAILED_TO_TERMINATE(104),
    RDNA_ERR_FAILED_TO_GET_CIPHERSALT(105),
    RDNA_ERR_FAILED_TO_GET_CIPHERSPECS(106),
    RDNA_ERR_FAILED_TO_GET_AGENT_ID(107),
    RDNA_ERR_FAILED_TO_GET_SESSION_ID(108),
    RDNA_ERR_FAILED_TO_GET_DEVICE_ID(109),
    RDNA_ERR_FAILED_TO_GET_SERVICE(110),
    RDNA_ERR_FAILED_TO_START_SERVICE(111),
    RDNA_ERR_FAILED_TO_STOP_SERVICE(112),
    RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET(113),
    RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET(114),
    RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST(115),
    RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE(116),
    RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM(117),
    RDNA_ERR_FAILED_TO_CHECK_CHALLENGE(118),
    RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE(119),
    RDNA_ERR_FAILED_TO_GET_CONFIG(120),
    RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES(121),
    RDNA_ERR_FAILED_TO_LOGOFF(122),
    RDNA_ERR_FAILED_TO_RESET_CHALLENGE(123),
    RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD(124),
    RDNA_ERR_FAILED_TO_SEND_DEV_DETAILS(125),
    RDNA_ERR_FAILED_TO_SET_DNS_SERVER(126),
    RDNA_ERR_USERID_EMPTY(127),
    RDNA_ERR_CHALLENGE_EMPTY(128),
    RDNA_ERR_FAILED_TO_SERIALIZE_JSON(129),
    RDNA_ERR_FAILED_TO_DESERIALIZE_JSON(130),
    RDNA_ERR_INVALID_CHALLENGE_CONFIG(131),
    RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES(132),
    RDNA_ERR_FAILED_TO_GET_REGISTERD_DEVICE_DETAILS(133),
    RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS(134),
    RDNA_ERR_USECASE_EMPTY(135),
    RDNA_ERR_DEVICE_DETAILS_EMPTY(136),
    RDNA_ERR_401_URL_EMPTY(137),
    RDNA_ERR_PASSWORD_EMPTY(138);
  }
  //..
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAErrorID) {
  RDNA_ERR_NONE = 0,

  RDNA_ERR_NOT_INITIALIZED = 1,
  RDNA_ERR_GENERIC_ERROR,
  RDNA_ERR_INVALID_VERSION,
  RDNA_ERR_INVALID_ARGS,
  RDNA_ERR_INVALID_CONTEXT,

  RDNA_ERR_FAILED_TO_CONNECT_VIA_PROXY = 21,
  RDNA_ERR_NULL_CALLBACKS,
  RDNA_ERR_INVALID_HOST,
  RDNA_ERR_INVALID_PORTNUM,
  RDNA_ERR_INVALID_AGENT_INFO,
  RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER,
  RDNA_ERR_FAILED_TO_AUTHENTICATE,
  RDNA_ERR_INVALID_SAVED_CONTEXT,
  RDNA_ERR_INVALID_HTTP_REQUEST,
  RDNA_ERR_INVALID_HTTP_RESPONSE,

  RDNA_ERR_INVALID_CIPHERSPECS = 42,
  RDNA_ERR_PLAINTEXT_EMPTY,
  RDNA_ERR_PLAINTEXT_LENGTH_INVALID,
  RDNA_ERR_CIPHERTEXT_EMPTY,
  RDNA_ERR_CIPHERTEXT_LENGTH_INVALID,

  RDNA_ERR_SERVICE_NOT_SUPPORTED = 61,
  RDNA_ERR_INVALID_SERVICE_NAME,

  RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE = 81,
  RDNA_ERR_FAILED_TO_GET_STREAM_TYPE,
  RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM,
  RDNA_ERR_FAILED_TO_END_STREAM,
  RDNA_ERR_FAILED_TO_DESTROY_STREAM,

  RDNA_ERR_FAILED_TO_INITIALIZE = 101,
  RDNA_ERR_FAILED_TO_PAUSERUNTIME,
  RDNA_ERR_FAILED_TO_RESUMERUNTIME,
  RDNA_ERR_FAILED_TO_TERMINATE,
  RDNA_ERR_FAILED_TO_GET_CIPHERSALT,
  RDNA_ERR_FAILED_TO_GET_CIPHERSPECS,
  RDNA_ERR_FAILED_TO_GET_AGENT_INFO,
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
  RDNA_ERR_FAILED_TO_SEND_DEV_DETAILS,
  RDNA_ERR_FAILED_TO_SET_DNS_SERVER,
  RDNA_ERR_USERID_EMPTY,
  RDNA_ERR_CHALLENGE_EMPTY,
  RDNA_ERR_FAILED_TO_SERIALIZE_JSON,
  RDNA_ERR_FAILED_TO_DESERIALIZE_JSON,
  RDNA_ERR_INVALID_CHALLENGE_CONFIG,
  RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES,
  RDNA_ERR_FAILED_TO_GET_REGISTERED_DEVICE_DETAILS,
  RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS,
  RDNA_ERR_USECASE_EMPTY,
  RDNA_ERR_DEVICE_DETAILS_EMPTY,
  RDNA_ERR_401_URL_EMPTY,
  RDNA_ERR_PASSWORD_EMPTY,
};
```

```cpp
typedef enum {
  RDNA_ERR_NONE = 0,

  RDNA_ERR_NOT_INITIALIZED = 1,
  RDNA_ERR_GENERIC_ERROR,
  RDNA_ERR_INVALID_VERSION,
  RDNA_ERR_INVALID_ARGS,
  RDNA_ERR_INVALID_CONTEXT,

  RDNA_ERR_FAILED_TO_CONNECT_VIA_PROXY = 21,
  RDNA_ERR_NULL_CALLBACKS,
  RDNA_ERR_INVALID_HOST,
  RDNA_ERR_INVALID_PORTNUM,
  RDNA_ERR_INVALID_AGENT_INFO,
  RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER,
  RDNA_ERR_FAILED_TO_AUTHENTICATE,
  RDNA_ERR_INVALID_SAVED_CONTEXT,
  RDNA_ERR_INVALID_HTTP_REQUEST,
  RDNA_ERR_INVALID_HTTP_RESPONSE,

  RDNA_ERR_INVALID_CIPHERSPECS = 42,
  RDNA_ERR_PLAINTEXT_EMPTY,
  RDNA_ERR_PLAINTEXT_LENGTH_INVALID,
  RDNA_ERR_CIPHERTEXT_EMPTY,
  RDNA_ERR_CIPHERTEXT_LENGTH_INVALID,

  RDNA_ERR_SERVICE_NOT_SUPPORTED = 61,
  RDNA_ERR_INVALID_SERVICE_NAME,

  RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE = 81,
  RDNA_ERR_FAILED_TO_GET_STREAM_TYPE,
  RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM,
  RDNA_ERR_FAILED_TO_END_STREAM,
  RDNA_ERR_FAILED_TO_DESTROY_STREAM,

  RDNA_ERR_FAILED_TO_INITIALIZE = 101,
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
  RDNA_ERR_FAILED_TO_SEND_DEV_DETAILS,
  RDNA_ERR_FAILED_TO_SET_DNS_SERVER,
  RDNA_ERR_USERID_EMPTY,
  RDNA_ERR_CHALLENGE_EMPTY,
  RDNA_ERR_FAILED_TO_SERIALIZE_JSON,
  RDNA_ERR_FAILED_TO_DESERIALIZE_JSON,
  RDNA_ERR_INVALID_CHALLENGE_CONFIG,
  RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES,
  RDNA_ERR_FAILED_TO_GET_REGISTERED_DEVICE_DETAILS,
  RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS,
  RDNA_ERR_USECASE_EMPTY,
  RDNA_ERR_DEVICE_DETAILS_EMPTY,
  RDNA_ERR_401_URL_EMPTY,
  RDNA_ERR_PASSWORD_EMPTY,  
} RDNAErrorID;
```

Error ID | Value | Meaning
-------- | ----- | -------
RDNA_ERR_NONE | 0  | The operation is successful and no error has occured
RDNA_ERR_NOT_INITIALIZED | 1 | The API Runtime is not initialized
RDNA_ERR_GENERIC_ERROR | 2 | Generic error has occured
RDNA_ERR_INVALID_VERSION | 3 | The SDK Version is invalid or unsupported
RDNA_ERR_INVALID_ARGS | 4 | The argument(s) passed to the API is invalid
RDNA_ERR_INVALID_CONTEXT| 5 | The context passed to the API is invalid
RDNA_ERR_FAILED_TO_CONNECT_VIA_PROXY | 21 | Failed to connect to REL-ID Gateway Server via proxy.
RDNA_ERR_NULL_CALLBACKS | 22 | The callback/ptr passed in is null
RDNA_ERR_INVALID_HOST | 23 | The hostname/IP is null or empty
RDNA_ERR_INVALID_PORTNUM | 24 | The port number is invalid
RDNA_ERR_INVALID_AGENT_INFO | 25 | The agent info is invalid (check the agent info blob received by Admin)
RDNA_ERR_FAILED_TO_CONNECT_TO_SERVER | 26 | Failed to connect to REL-ID Gateway Server
RDNA_ERR_FAILED_TO_AUTHENTICATE | 27 | Failed to authenticate with REL-ID Gateway Server
RDNA_ERR_INVALID_SAVED_CONTEXT | 28 | The saved context passed to Resume is invalid
RDNA_ERR_INVALID_HTTP_REQUEST | 29 | The Http Request passed to Encrypt Http API is invalid
RDNA_ERR_INVALID_HTTP_RESPONSE | 30 | The Http Request passed to Decrypt Http API is invalid
RDNA_ERR_INVALID_CIPHERSPECS | 42 | The cipher spec passed in is invalid
RDNA_ERR_PLAINTEXT_EMPTY | 43 | The plain text passed to Encrypt API is empty
RDNA_ERR_PLAINTEXT_LENGTH_INVALID | 44 | The plain text length passed to Encrypt API is invalid
RDNA_ERR_CIPHERTEXT_EMPTY | 45 | The cipher text passed to Decrypt API is empty
RDNA_ERR_CIPHERTEXT_LENGTH_INVALID | 46 | The cipher text length passed to Decrypt API is invalid
RDNA_ERR_SERVICE_NOT_SUPPORTED | 61 | The service provided is not supported
RDNA_ERR_INVALID_SERVICE_NAME | 62 | The service name passed in is invalid
RDNA_ERR_FAILED_TO_GET_STREAM_PRIVACYSCOPE | 81 | Failed to get stream privacy scope
RDNA_ERR_FAILED_TO_GET_STREAM_TYPE | 82 | Failed to get stream type
RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM | 83 | Failed to write into privacy stream
RDNA_ERR_FAILED_TO_END_STREAM | 84 | Failed to end privacy stream
RDNA_ERR_FAILED_TO_DESTROY_STREAM | 85 | Failed to destroy privacy stream
RDNA_ERR_FAILED_TO_INITIALIZE | 101 | Failed to initialize
RDNA_ERR_FAILED_TO_PAUSERUNTIME | 102 | Failed to pause runtime
RDNA_ERR_FAILED_TO_RESUMERUNTIME | 103 | Failed to resume runtime
RDNA_ERR_FAILED_TO_TERMINATE | 104 | Failed to terminate
RDNA_ERR_FAILED_TO_GET_CIPHERSALT | 105 | Failed to get cipher salt
RDNA_ERR_FAILED_TO_GET_CIPHERSPECS | 106 | Failed to get cipherspecs
RDNA_ERR_FAILED_TO_GET_AGENT_ID | 107 | Failed to get agent id
RDNA_ERR_FAILED_TO_GET_SESSION_ID | 108 | Failed to get session id
RDNA_ERR_FAILED_TO_GET_DEVICE_ID | 109 | Failed to get device id
RDNA_ERR_FAILED_TO_GET_SERVICE | 110 | Failed to get service
RDNA_ERR_FAILED_TO_START_SERVICE | 111 | Failed to start service
RDNA_ERR_FAILED_TO_STOP_SERVICE | 112 | Failed to stop service
RDNA_ERR_FAILED_TO_ENCRYPT_DATA_PACKET | 113 | Failed to encrypt data packet
RDNA_ERR_FAILED_TO_DECRYPT_DATA_PACKET | 114 | Failed to decrypt data packet
RDNA_ERR_FAILED_TO_ENCRYPT_HTTP_REQUEST | 115 | Failed to encrypt HTTP request
RDNA_ERR_FAILED_TO_DECRYPT_HTTP_RESPONSE | 116 | Failed to decrypt HTTP response
RDNA_ERR_FAILED_TO_CREATE_PRIVACY_STREAM | 117 | Failed to create privacy stream
RDNA_ERR_FAILED_TO_CHECK_CHALLENGE | 118 | Failed to check challenge response
RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE | 119 | Failed to update challenge
RDNA_ERR_FAILED_TO_GET_CONFIG | 120 | Failed to retrieve configuration 
RDNA_ERR_FAILED_TO_GET_ALL_CHALLENGES | 121 | Failed to retrieve list of all challenges
RDNA_ERR_FAILED_TO_LOGOFF | 122 | Failed to log off the user
RDNA_ERR_FAILED_TO_RESET_CHALLENGE | 123 | Failed to reset challenge
RDNA_ERR_FAILED_TO_DO_FORGOT_PASSWORD | 124 | Failed to reset password via forgot password API
RDNA_ERR_FAILED_TO_SEND_DEV_DETAILS | 125 | Failed to send device details to the server
RDNA_ERR_FAILED_TO_SET_DNS_SERVER | 126 | Failed to set DNS server
RDNA_ERR_USERID_EMPTY | 127 | Userid field is empty
RDNA_ERR_CHALLENGE_EMPTY | 128 | Challenge field is empty
RDNA_ERR_FAILED_TO_SERIALIZE_JSON | 129 | Failed to serialize to internal representation
RDNA_ERR_FAILED_TO_DESERIALIZE_JSON | 130 | Failed to deserialize from internal representation
RDNA_ERR_INVALID_CHALLENGE_CONFIG | 131 | Invalid challenge configuration 
RDNA_ERR_FAILED_TO_GET_POST_LOGIN_CHALLENGES | Error while attempting to fetch post-login challenges
RDNA_ERR_FAILED_TO_GET_REGISTERED_DEVICE_DETAILS | Error while attempting to get details of the registered devices of the user
RDNA_ERR_FAILED_TO_UPDATE_DEVICE_DETAILS | Failed to update device details of the user
RDNA_ERR_USECASE_EMPTY | The input parameter to GetConfig API cannot be EMPTY or NULL.
RDNA_ERR_DEVICE_DETAILS_EMPTY | Received empty device details list
RDNA_ERR_401_URL_EMPTY | HTTP authentication credentials callback does not specify the URL or the URL is NULL 
RDNA_ERR_PASSWORD_EMPTY |  Empty password in response is not allowed


Error ID | Value | Meaning
-------- | ----- | -------
NONE | 0  | The operation is successful and no error has occured
NOT_INITIALIZED | 1 | The API Runtime is not initialized
GENERIC_ERROR | 2 | Generic error has occured
INVALID_VERSION | 3 | The SDK Version is invalid or unsupported
INVALID_ARGS | 4 | The argument(s) passed to the API is invalid
INVALID_CONTEXT| 5 | The context passed to the API is invalid
FAILED_TO_CONNECT_VIA_PROXY | 21 | Failed to connect to REL-ID Gateway Server via proxy.
NULL_CALLBACKS | 22 | The callback/ptr passed in is null
INVALID_HOST | 23 | The hostname/IP is null or empty
INVALID_PORTNUM | 24 | The port number is invalid
INVALID_AGENT_INFO | 25 | The agent info is invalid (check the agent info blob received by Admin)
FAILED_TO_CONNECT_TO_SERVER | 26 | Failed to connect to REL-ID Gateway Server
FAILED_TO_AUTHENTICATE | 27 | Failed to authenticate with REL-ID Gateway Server
INVALID_SAVED_CONTEXT | 28 | The saved context passed to Resume is invalid
INVALID_HTTP_REQUEST | 29 | The Http Request passed to Encrypt Http API is invalid
INVALID_HTTP_RESPONSE | 30 | The Http Request passed to Decrypt Http API is invalid
INVALID_CIPHERSPECS | 42 | The cipher spec passed in is invalid
RDNA_ERR_PLAINTEXT_EMPTY | 43 | The plain text passed to Encrypt API is empty
RDNA_ERR_PLAINTEXT_LENGTH_INVALID | 44 | The plain text length passed to Encrypt API is invalid
RDNA_ERR_CIPHERTEXT_EMPTY | 45 | The cipher text passed to Decrypt API is empty
RDNA_ERR_CIPHERTEXT_LENGTH_INVALID | 46 | The cipher text length passed to Decrypt API is invalid
RDNA_ERR_SERVICE_NOT_SUPPORTED | 61 | The service provided is not supported
RDNA_ERR_INVALID_SERVICE_NAME | 62 | The service name passed in is invalid
FAILED_TO_GET_STREAM_PRIVACYSCOPE | 81 | Failed to get stream privacy scope
RDNA_ERR_FAILED_TO_GET_STREAM_TYPE | 82 | Failed to get stream type
RDNA_ERR_FAILED_TO_WRITE_INTO_STREAM | 83 | Failed to write into privacy stream
RDNA_ERR_FAILED_TO_END_STREAM | 84 | Failed to end privacy stream
RDNA_ERR_FAILED_TO_DESTROY_STREAM | 85 | Failed to destroy privacy stream
RDNA_ERR_FAILED_TO_INITIALIZE | 101 | Failed to initialize
RDNA_ERR_FAILED_TO_PAUSERUNTIME | 102 | Failed to pause runtime
RDNA_ERR_FAILED_TO_RESUMERUNTIME | 103 | Failed to resume runtime
RDNA_ERR_FAILED_TO_TERMINATE | 104 | Failed to terminate
RDNA_ERR_FAILED_TO_GET_CIPHERSALT | 105 | Failed to get cipher salt
RDNA_ERR_FAILED_TO_GET_CIPHERSPECS | 106 | Failed to get cipherspecs
RDNA_ERR_FAILED_TO_GET_AGENT_ID | 107 | Failed to get agent id
RDNA_ERR_FAILED_TO_GET_SESSION_ID | 108 | Failed to get session id
RDNA_ERR_FAILED_TO_GET_DEVICE_ID | 109 | Failed to get device id
RDNA_ERR_FAILED_TO_GET_SERVICE | 110 | Failed to get service
RDNA_ERR_FAILED_TO_START_SERVICE | 111 | Failed to start service
RDNA_ERR_FAILED_TO_STOP_SERVICE | 112 | Failed to stop service
FAILED_TO_ENCRYPT_DATA_PACKET | 113 | Failed to encrypt data packet
FAILED_TO_DECRYPT_DATA_PACKET | 114 | Failed to decrypt data packet
FAILED_TO_ENCRYPT_HTTP_REQUEST | 115 | Failed to encrypt HTTP request
FAILED_TO_DECRYPT_HTTP_RESPONSE | 116 | Failed to decrypt HTTP response
FAILED_TO_CREATE_PRIVACY_STREAM | 117 | Failed to create privacy stream
RDNA_ERR_FAILED_TO_CHECK_CHALLENGE | 118 | Failed to check challenge response
RDNA_ERR_FAILED_TO_UPDATE_CHALLENGE | 119 | Failed to update challenge
RDNA_ERR_FAILED_TO_GET_CONFIG | 120 | Failed to retrieve configuration 
FAILED_TO_GET_ALL_CHALLENGES | 121 | Failed to retrieve list of all challenges
RDNA_ERR_FAILED_TO_LOGOFF | 122 | Failed to log off the user
RDNA_ERR_FAILED_TO_RESET_CHALLENGE | 123 | Failed to reset challenge
FAILED_TO_DO_FORGOT_PASSWORD | 124 | Failed to reset password via forgot password API
RDNA_ERR_FAILED_TO_SEND_DEV_DETAILS | 125 | Failed to send device details to the server
RDNA_ERR_FAILED_TO_SET_DNS_SERVER | 126 | Failed to set DNS server
RDNA_ERR_USERID_EMPTY | 127 | Userid field is empty
RDNA_ERR_CHALLENGE_EMPTY | 128 | Challenge field is empty
RDNA_ERR_FAILED_TO_SERIALIZE_JSON | 129 | Failed to serialize to internal representation
RDNA_ERR_FAILED_TO_DESERIALIZE_JSON | 130 | Failed to deserialize from internal representation
RDNA_ERR_INVALID_CHALLENGE_CONFIG | 131 | Invalid challenge configuration 
FAILED_TO_GET_POST_LOGIN_CHALLENGES | Error while attempting to fetch post-login challenges
FAILED_TO_GET_REGISTERED_DEVICE_DETAILS | Error while attempting to get details of the registered devices of the user
FAILED_TO_UPDATE_DEVICE_DETAILS | Failed to update device details of the user
RDNA_ERR_USECASE_EMPTY | The input parameter to GetConfig API cannot be EMPTY or NULL.
RDNA_ERR_DEVICE_DETAILS_EMPTY | Received empty device details list
RDNA_ERR_401_URL_EMPTY | HTTP authentication credentials callback does not specify the URL or the URL is NULL 
RDNA_ERR_PASSWORD_EMPTY |  Empty password in response is not allowed


## Method identifiers (enum)

These identifiers are used to identify the routine when the ```StatusUpdate``` callback routine is invoked.

```c
typedef enum {
  CORE_METH_NONE = 0,
  CORE_METH_INITIALIZE,
  CORE_METH_TERMINATE,
  CORE_METH_RESUME,
  CORE_METH_PAUSE,
} e_core_method_t;
```

```java
public abstract class RDNA {
  //..
  public enum RDNAMethodID {
    RDNA_METH_NONE(0),
    RDNA_METH_INITIALIZE(1),
    RDNA_METH_TERMINATE(2),
    RDNA_METH_RESUME(3),
    RDNA_METH_PAUSE(4);
    RDNA_METH_GET_CONFIG(5),
    RDNA_METH_CHECK_CHALLENGE(6),
    RDNA_METH_UPDATE_CHALLENGE(7),
    RDNA_METH_GET_ALL_CHALLENGES(8),
    RDNA_METH_LOGOFF(9),
    RDNA_METH_FORGOT_PASSWORD(10),
    RDNA_METH_GET_POST_LOGIN_CHALLENGES(11);
    RDNA_METH_GET_DEVICE_DETAILS(12),
    RDNA_METH_UPDATE_DEVICE_DETAILS(13),
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
  RDNA_METH_FORGOT_PASSWORD,
  RDNA_METH_GET_POST_LOGIN_CHALLENGES,
  RDNA_METH_GET_DEVICE_DETAILS,
  RDNA_METH_UPDATE_DEVICE_DETAILS,
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
  RDNA_METH_FORGOT_PASSWORD,
  RDNA_METH_GET_POST_LOGIN_CHALLENGES,
  RDNA_METH_GET_DEVICE_DETAILS,
  RDNA_METH_UPDATE_DEVICE_DETAILS,
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
RDNA_METH_FORGOT_PASSWORD | ForgotPassword runtime method
RDNA_METH_GET_POST_LOGIN_CHALLENGES | PostLoginChallenges runtime method

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

```c
typedef enum {
  CORE_PORT_TYPE_PROXY = 0,
  CORE_PORT_TYPE_PORTF,
} e_port_type_t;
```

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

```c
```

```java
public abstract class RDNA {
  //...
  public static class RDNAChallenge {
    public final String name;
    public final RDNAChallengeType type;
    public final int index;
    public final LinkedHashMap<String, String> info;
    public final String[] prompts;
    public final int attemptsLeft;
    public final boolean shouldValidateResponse;
    public final String[] responsePolicies;
    public final int subChallengeIndex;
    public String responseKey;
    public Object responseValue;
	public RDNAChallengeOpMode challengeOperation;
  }
}
```

```objective_c
@interface RDNAChallenge : NSObject

  @property (nonatomic, strong, readonly) NSString *name;
  @property (nonatomic, assign, readonly) RDNAChallengePromptType type;
  @property (nonatomic, assign, readonly) int index;
  @property (nonatomic, strong, readonly) NSMutableArray *info;
  @property (nonatomic, strong, readonly) NSArray *prompts;
  @property (nonatomic, assign, readonly) int attemptsLeft;
  @property (nonatomic, assign, readonly) BOOL shouldValidateResponse;
  @property (nonatomic, strong, readonly) NSArray *responsePolicies;
  @property (nonatomic, assign, readonly) int responseCount;
  @property (nonatomic, strong)           NSString *responseKey;
  @property (nonatomic, strong)           NSObject *responseValue;
  @property (nonatomic, assign, readonly) RDNAChallengeOpMode challengeOperation;
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

```c
```

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


## RDNAChallengeStatusCode (Enumeration)

The ```RDNAChallengeStatusCode``` represents the result of the previous ```CheckChallengeResponse``` or ```UpdateChallenge``` API.  

```c
```

```java
public abstract class RDNA {
  //...
  public static enum RDNAChallengeStatusCode {
    RDNA_CHLNG_STATUS_SUCCESS(0),
    RDNA_CHLNG_STATUS_NO_SUCH_USER)(1),
    RDNA_CHLNG_STATUS_USER_SUSPENDED(2),
    RDNA_CHLNG_STATUS_USER_BLOCKED(3),
    RDNA_CHLNG_STATUS_USER_ALREADY_ACTIVATED(4),
    RDNA_CHLNG_STATUS_INVALID_ACT_CODE(5),
    RDNA_CHLNG_STATUS_UPDATE_CHALLENGES_FAILED(6),
    RDNA_CHLNG_STATUS_CHALLENGE_RESPONSE_VALIDATION_FAILED(7),
    RDNA_CHLNG_STATUS_DEVICE_VALIDATION_FAILED(8),
    RDNA_CHLNG_STATUS_INVALID_CHALLENGE_LIST(9),
    RDNA_CHLNG_STATUS_INTERNAL_SERVER_ERROR(10),
    RDNA_CHLNG_STATUS_UNKNOWN_ERROR(11);
  }
}
```

```objective_c
typedef NS_ENUM(NSInteger, RDNAChallengeStatusCode) {
  RDNA_CHLNG_STATUS_SUCCESS = 0,
  RDNA_CHLNG_STATUS_NO_SUCH_USER,
  RDNA_CHLNG_STATUS_USER_SUSPENDED,
  RDNA_CHLNG_STATUS_USER_BLOCKED,
  RDNA_CHLNG_STATUS_USER_ALREADY_ACTIVATED,
  RDNA_CHLNG_STATUS_INVALID_ACT_CODE,
  RDNA_CHLNG_STATUS_UPDATE_CHALLENGES_FAILED,
  RDNA_CHLNG_STATUS_CHALLENGE_RESPONSE_VALIDATION_FAILED,
  RDNA_CHLNG_STATUS_DEVICE_VALIDATION_FAILED,
  RDNA_CHLNG_STATUS_INVALID_CHALLENGE_LIST,
  RDNA_CHLNG_STATUS_INTERNAL_SERVER_ERROR,
  RDNA_CHLNG_STATUS_UNKNOWN_ERROR
};
```

```cpp
typedef enum {
  RDNA_CHLNG_STATUS_SUCCESS = 0,
  RDNA_CHLNG_STATUS_NO_SUCH_USER,
  RDNA_CHLNG_STATUS_USER_SUSPENDED,
  RDNA_CHLNG_STATUS_USER_BLOCKED,
  RDNA_CHLNG_STATUS_USER_ALREADY_ACTIVATED,
  RDNA_CHLNG_STATUS_INVALID_ACT_CODE,
  RDNA_CHLNG_STATUS_UPDATE_CHALLENGES_FAILED,
  RDNA_CHLNG_STATUS_CHALLENGE_RESPONSE_VALIDATION_FAILED,
  RDNA_CHLNG_STATUS_DEVICE_VALIDATION_FAILED,
  RDNA_CHLNG_STATUS_INVALID_CHALLENGE_LIST,
  RDNA_CHLNG_STATUS_INTERNAL_SERVER_ERROR,
  RDNA_CHLNG_STATUS_UNKNOWN_ERROR
} RDNAChallengeStatusCode;
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
<b>RDNA_CHLNG_STATUS_UNKNOWN_ERROR</b> | This status is returned when an error or unknown origin has occurred. The only recourse is to contact the administrator.

## RDNAChallengeOpMode (Enumeration)

This enumeration is used to indicate to the user about the intended action for the challenge, namely whether this is a challenge verification operation or a challenge update operation. 

```c
```

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

## RDNAChallengeStatus

This class defines the status of the response of previous challenge recieved by the server. The following are the members of the class :

```c
```

```java
public abstract class RDNA {
  //...
  public static class RDNAChallengeStatus{
    public String message;
    public RDNAChallengeStatusCode statusCode;

	public RDNAChallengeStatus(String message, RDNAChallengeStatusCode statusCode) {
      this.message = message;
      this.statusCode = statusCode;
    }
  }
}
```

```objective_c
@interface RDNAChallengeStatus : NSObject
  @property (nonatomic, strong) NSString *message;
  @property (nonatomic, assign) RDNAChallengeStatusCode statusCode;
@end
```

```cpp
typedef struct RDNAChallengeStatus_s {
  std::string message;
  RDNAChallengeStatusCode statusCode;
  RDNAChallengeStatus_s () : message(""), statusCode(RDNA_CHLNG_STATUS_SUCCESS)
  {}
} RDNAChallengeStatus;
```

Member | Description
------ | -----------
<b>message</b> | This is a string representation of the error that occurred. This would be implementation specific.
<b>statusCode</b> | This is the statusCode representing the error that occurred during the processing of the challenge response.

## DeviceStatus (Enumeration)
Following enums are defined for the device management feature, which will provide the device details of a specific device, for example the device status and device binding 

```c
```

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

This is the first routine that must be called to bootstrap the REL-ID API runtime up. The arguments to this routine are described in the below table.

This routine starts up the API runtime (including a DNA - <i>Digital Network Adapter</i> - instance), and in the process registers the API-client supplied callback routines with the API runtime context. This is a non-blocking routine, and when it returns, it will have initiated the process of creation of a REL-ID session in PRIMARY state, using the supplied <i>agent information</i> - the progress of this operation is notified to the API-client application via the status update (core API), and event notification (wrapper API), callback routines supplied.

A reference to the context of the newly created API runtime is returned to the API-client.

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
 void*  pvAppCtx);
```

```java
public abstract class RDNA {
  //..
  public static
    RDNAStatus<RDNA>
    initialize(
      String agentInfo,
      RDNACallbacks
             callbacks,
      String authGatewayHNIP,
      int    authGatewayPORT,
      String cipherSpecs,
      String cipherSalt,
      RDNAProxySettings
             proxySettings,
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
         AppContext:(id)appCtx;
@end
```

```cpp
class RDNA
{
public:
  static int
  initialize
  (RDNA**         ppRuntimeCtx,
   std::string    agentInfo,
   RDNACallbacks* callbacks,
   std::string    authGatewayHNIP,
   unsigned short authGatewayPORT,
   std::string    cipherSpec,
   std::string    cipherSalt,
   RDNAProxySettings*
                  pProxySettings,
   void*          appCtx);
}
```

Argument&nbsp;[in/out] | Description
---------------------- | -----------
API&nbsp;Context&nbsp;[out] | The newly created API runtime context.<br>In Java, an instance of ```RDNA``` is returned in an ```RDNAStatus<RDNA>``` object.<br>In Core, Objective-C and C++, an out parameter is populated.
Agent&nbsp;Info&nbsp;[in] | Software identity information for the API-runtime to authenticate and establish primary session connectivity with the REL-ID platform backend
Callbacks&nbsp;[in] | Callback routines supplied by the API-client application. These are invoked by the API-runtime.
Auth&nbsp;Gateway&nbsp;HNIP&nbsp;[in] | <b>H</b>ost<b>N</b>ame/<b>IP</b>-address of the REL-ID Authentication Gateway against which the API-runtime must establish mutual authenticated connectivity (on behalf of the API-client application)
Auth&nbsp;Gateway&nbsp;PORT&nbsp;[in] | <b>PORT</b>-number at ```AuthGatewayHNIP```, on which the REL-ID Authentication Gateway is accessible (accepting connections)
Cipher&nbsp;Specs&nbsp;[in] | The cipher specifications (encryption algorithm, padding scheme and cipher-mode) to be used as a default for this API-Runtime context. If passed as empty, then the default Cipher Spec of the API-SDK will be used as default.
Cipher&nbsp;Salt&nbsp;[in] | The salt/IV to be used as default salt/IV for this API-Runtime context. If passed as empty, then the default Cipher Salt of the API-SDK will be used as default.
Application&nbsp;Context&nbsp;[in] | Opaque reference to API-client application context that is never interpreted/modified by the API-runtime. This reference is supplied with each callback invocation to the API-client.
Proxy&nbsp;Settings&nbsp;[in] |Hostname/IPaddress and port-number for proxy to use when connecting to the Auth Gateway server. This is an optional parameter that may be null if it is not applicable


## Terminate Routine

```c
int
coreTerminate
(void*  pvRuntimeCtx);
```

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

When an API-client application no longer requires a session, for example when the end-user logs of the enterprise application, it can invoke the ```InvalidateAppSession``` and/or ```InvalidateUserSession``` routines to notify the REL-ID backend that the session is no longer valid and is not to be entertained anymore.

After the formation of user session - the app session is subsided by saving its state, the services related to app session is shutdown and the services related to user session is started. Hence after the invalidation of user session, the app session is again restored and the services related to app session is started as per its last subsided state.

## InvalidateAppSession routine

```c
int
coreInvalidateAppSession
(void* pvRuntimeCtx);
```

```java
public abstract class RDNA {
  //..
  public abstract int
    invalidateAppSession();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  - (int)invalidateAppSession;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  int invalidateAppSession();
  //..
}
```

This routine notifies the REL-ID backend that the application (PRIMARY) session present in the API-runtime context is to be invalidated. Accordingly the API-runtime, <i>forgets</i> the corresponding session ticket.

<aside class="notice"><b><u>Note</u></b> that at this point, since there is no application session present in the API-runtime, the only possible API interaction for the API-client, is to invoke <b>Terminate</b>. If subsequent REL-ID based access is required, successful <b>Initialize</b> invocation would be required to create new <b>PRIMARY</b> application session.
</aside>

## InvalidateUserSession routine

```c
int
coreInvalidateUserSession
(void* pvRuntimeCtx);
```

```java
public abstract class RDNA {
  //..
  public abstract int
    invalidateUserSession();
  //..
}
```

```objective_c
@interface RDNA : NSObject
  //..
  - (int)invalidateUserSession;
  //..
@end
```

```cpp
class RDNA
{
public:
  //..
  int invalidateUserSession();
  //..
}
```

This routine notifies the REL-ID backend that the user (SECONDARY) session present in the API-runtime context is to be invalidated. Accordingly the API-runtime, <i>forgets</i> the corresponding session ticket.

<aside class="notice"><b><u>Note</u></b> that at this point, since there is no user (SECONDARY) session present in the API-runtime, the API-client may only access backend services that are accessible by virtue of the application (PRIMARY) session present in the API-runtime context.
</aside>

# API - Service Access

These routines enable the API-client applications to retrieve the service structure for the backend enterprise service it requires to interact with, and use that information to safely interact with them.
 * The first 2 ```GetService...``` routines help retrieve the service information for the service - one of them looks it up using a logical unique name of the backend service and the other retrieves all available services for the current context
 * The second 2 ```ServiceAccess...``` routines are used to start/enable and stop/disable the access to the backend services.

## Information Retrieval

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

```c
typedef enum {
  CORE_PRIVACY_SCOPE_SESSION = 0x01, /* use session-specific keys */
  CORE_PRIVACY_SCOPE_DEVICE  = 0x02, /* use device-specific keys  */
  CORE_PRIVACY_SCOPE_USER    = 0x03, /* use user-specific keys    */
  CORE_PRIVACY_SCOPE_AGENT   = 0x04, /* use agent-specific keys   */
} e_core_privacy_scope_t;
```

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

```java
public abstract class RDNA {
  //..
  public abstract RDNAStatus<byte[]> pauseRuntime();

  public static RDNAStatus<RDNA> resumeRuntime(
         byte[] state, RDNACallbacks callbacks,
         RDNAProxySettings proxySettings, Object appCtx);
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

```c
```

```java
public abstract class RDNA {
  //..
  public abstract int checkChallenges(RDNAChallenge[] challenges,String userID);
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

As part of the API call sequence to authenticate an end-user, the API-client receives challenges in the form of RDNAChallenge objects/structs. The API-client would then receive the response to the challenge from the end-user, and use the ```checkChallengeResponse``` API to pass the challenge responses to the server. The response will be validated by the server. The server would then process the response and the API-client will receive a ```RDNAStatusCheckChallengesResponse``` object representing the result of processing the response for the challenge. The server response would indicate that whether the response was validate successfully or not.

<aside class="notice">This API should only be called to authenticate an end-user, and post authentication this API should not be used. Please refer to <u><i>getPostLoginChallenges</i></u> API for getting the end-user to authenticate, post successful authentication in the same session</aside>

## UpdateChallenges



```c
```

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

```c
```

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


## ForgotPassword

```c
```

```java
public abstract class RDNA {
  //..
  public abstract int forgotPassword(String userID);
}
```

```objective_c
@interface RDNA
  //...
  - (int)forgotPassword:(NSString *)userID;
@end
```

```cpp
class RDNA {
  //...
  int forgotPassword(std::string userID);
}
```


## GetAllChallenges

```c
```

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

```c
```

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

```c
```

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

```c
```

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
  @property (nonatomic, copy) NSString *deviceName;
  @property (nonatomic, readonly) RDNADeviceBinding deviceBinding;
  @property (nonatomic, readonly) RDNADeviceStatus deviceStatus;
  @property (nonatomic, readonly, copy) NSString *deviceRegistrationTime;
  @property (nonatomic, readonly, copy) NSString *lastAccessTime;
  @property (nonatomic, readonly, copy) NSString *lastLoginStatus;

  - (void)deleteDevice;
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

```c
```

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

```c
```

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

# API - Miscelleneous

## SetDNSServers

```c
```

```java
public abstract class RDNA {
  //..
  public abstract int setDnsServer(String[] dnsServer);
}
```

```objective_c
@interface RDNA
  //...
  - (int)setDNSServers:(NSArray *)DNSServers;
@end
```

```cpp
class RDNA {
  //...
  int setDNSServers(vector<std::string> DNSServers);
}
```

This API allows the API-client to explicitly add additional DNS servers, which the runtime will query when performing hostname resolution.
