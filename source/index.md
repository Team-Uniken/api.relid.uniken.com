---
title: REL-ID SDK (work-in-progress)

language_tabs:
  - c: ANSI C
  - java: Java
  - objective_c: Objective C
  - cpp: C++

toc_footers:
  - <a href='http://www.uniken.com'>Uniken Website</a>

<!--includes:
  - errors-->

search: true
---

<aside class="notice"><b><u>Disclaimer</u></b> -
<br>
This REL-ID API specification is a <u>working pre-release draft</u> copy - <i>it is under frequent change at the moment</i>.
<br>
Lots of TODOs in the specifications - to be filled in / updated by engineering team - will be uploaded/updated here as and when received.
<br>
Last updated on Monday, 12 October 2015, at 1945 HK Time
</aside>

# Introduction

Welcome to the REL-ID API!

REL-ID is a distributed digital trust platform that connects things - people, networks, devices, applications - securely. It creates a closed, private, massively scalable, app-to-app networking ecosystem to protect enterprise applications and data from unauthorized and fraudulent access, and tampering.

The REL-ID API enables applications to be written to leverage the path-breaking security REL-ID provides. The API SDK is shipped with client-side API libraries, reference implementations and documentation, as well as the server-side REL-ID platform.

The core API is implemented in ANSI C, and has wrappers/bindings for Java (Android), Objective-C (iOS) and C++ (Windows Phone).

<aside class="notice">JavaScript bindings for hybrid application frameworks will be made available in future</aside>

At a high level, the REL-ID API provides the following features that enable applications to leapfrog ahead in terms of securing themselves - mutual identity and authentication, device fingerprinting and binding, privacy of data, and the digital network adapter (aka DNA). An additional feature of capability to pause and resume the API runtime, on demand, has been provided particularly keeping mobile smartphone device platforms in mind.

## Mutual identity and authentication

<u>Relative Identity</u> (or <u>REL-ID</u> for short) is a mutual identity that encapsulates/represents uniquely, the relationship between 2 parties/entities. This mutual identity is mathematically split in two, and one part each is distributed securely to the communicating parties. The identity of each end-point party/entity is thus relative to the identity of the other end-point party/entity. REL-ID can be used to represent the relationship between user and app, user and user, or app and other app, thus providing a holistic digital identity model

The protocol handshake that authenticates the REL-ID between 2 parties/entities is RMAK – which is short form for ‘<b><u>R</u>EL-ID <u>M</u>utual <u>A</u>uthentication and <u>K</u>ey-exchange</b>’. It is a unique and patented protocol handshake that enables MITM-resistant, true mutual authentication. As specified in the name, key-exchange is a by-product of a successful RMAK handshake and the exchanged keys are used for downstream privacy of communications over the authenticated channel.

<aside class="notice"><i><b><u>Agent REL-ID</u></b> and <b><u>User REL-ID</u></b></i> -
<li>An <u><b>Agent REL-ID</b></u> is used to represent the relationship between software applicaition and the REL-ID platform backend.
<li>An <u><b>User REL-ID</b></u> is used to represent the relationship between end-user of the application and the REL-ID platform backend.
<br>
<i>Note that the REL-ID platform backend represents the enterprise.</i>
</aside>

## Device fingerprinting and binding

Every end-point computing device has a number of unique identities associated with it – this includes hardware OEM identities, as well as software identities at both OS platform and application software level. The end-point device’s fingerprint is created by collecting these various identities, and using them together to uniquely identify it. 

The REL-ID platform’s multi-factor authentication (MFA) is implemented by binding the device’s fingerprint/identity with the REL-ID of the user/app – thus ensuring that REL-ID-based access is provided only from whitelisted end-point devices (those with identities/fingerprints bound to the relevant REL-IDs).

## Access to backend enterprise services

After successful mutual authentication between REL-ID API client-side and REL-ID platform backend (the REL-ID <b>Authentication Gateway</b>), the <b>REL-ID Digital Network Adapter</b> (or <b>RDNA</b> for short) is setup inside the API runtime for enabling secure communications of the API-client application with its enterprise backend services. These services are hidden behind the REL-ID <b>Access Gateway(s)</b> and are accessible ONLY via the RDNA, which possesses the capability to tunnel/relay/patch through application traffic between the client app and its backend services via an Access Gateway.

The backend coordinates of the enterprise services that are accessible for a given software agent REL-ID or user REL-ID are configured into the REL-ID platform on the REL-ID <b>Gateway Manager</b> console. During this configuration, these coordinates are supplied in the form that they are reachable from the REL-ID Access Gateway(s), i.e. using the internally accessible coordinates (IP addresses and port numbers).

The RDNA provides multiple mechanisms to enable this tunneling of traffic - a HTTP proxy facade, and any number of forwarded TCP ports corresponding to backend enterprise service TCP coordinates.

### HTTP Proxy facade

The API client uses a standard HTTP library to make its HTTP requests, instructing the library to to make the request via the specified HTTP proxy running on the loopback adapter (127.0.0.1/::1)

### Forwarded port facade

The API client connects directly to a locally present port which represents the backend enterprise service coordinate

Facade | Description
------ | -----------
HTTP&nbsp;Proxy | The API-client uses a standard HTTP library to make its HTTP requests, instructing the library to to make the request via the specified HTTP proxy running on local loopback adapter (127.0.0.1/::1)
Forwarded&nbsp;Port | The API client connects directly to a locally present port which represents the backend enterprise service coordinate

## Privacy of Data

One of the important functionalities the API SDK provides is to encrypt and decrypt application data, on demand. The following scopes of privacy are provided - session-scope, device-scope, user-scope and agent-scope. In all cases, the API-client application can additionally specify cipher-specs for the encryption algorithm and mode to use, as well as specify its own salting vector (or IV).

Privacy Scope | Description
------------- | -----------
Session | The keys used are specific to the REL-ID session and valid for the duration of the session. These keys are primarily used to secure the privacy of data in transit between the API-client application and the REL-ID DNA, as well as between the API-client application and its backend services.
Device | The keys used are specific to the end-point device. These keys are primarily used by the API-client application to secure the privacy of data that the API-client application might want to persist on the device.
User | The keys used are specific to the user.
Agent | The keys used are specific to the agent (i.e. the application using the API)

## Pause-resume of API runtime

Applications written for mobile platforms like Android, iOS and WindowsPhone generally require to handle the 'OS is pausing your application' and the 'OS is resuming your application' events.

The REL-ID API includes ```PauseRuntime``` and ```ResumeRuntime``` routines that terminate-and-save the runtime state and restore-and-reinitialize the runtime state respectively:

Routine | Description
------- | -----------
PauseRuntime | Routine that terminates the API runtime, saves a <u><i>private</i></u> copy of the relevant data structures, and returns an encoded dump of the saved information as a null-terminated string.<br><br>When an API-client application is asked to <i>pause</i> itself, it anyway saves its runtime state in a bundle of some kind and persists it (either using OS services, or separately where it knows to look when the application is resumed)<br>At this point, the API-client application must also invoke the ```PauseRuntime``` routine and save the returned string as well.
ResumeRuntime | Routine that accepts a previously saved <u><i>private</i></u> copy of the API runtime, and restores the API runtime back to the saved state while validating some of the saved state (like session information - validity/life, other information).<br><br>When an API-client application is asked to <i>resume</i> itself, it anyway restores its own runtime status from a previously persisted information bundle of some kind<br><b>BEFORE</b> it does that, it should first restore the previously persisted <i><u>private</u></i> copy of the API runtime state (from a previously executed ```PauseRuntime```) and invoke the ```ResumeRuntime``` routine passing this state information in to it.

## Non-blocking API

The API is written with non-blocking interactions in mind - none of the API routines will block for any kind of network I/O.

When an API routine requires to perform network I/O with backend services in order to service the API-client, that I/O is delegated to the DNA which is part of the API runtime, and the results are communicated back to via callback routines supplied by the API-client. The DNA itself uses non-blocking I/O for all the network communication it performs. 

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
is applicable only when an API-client application uses the REL-ID API for the purpose of its user identity as well. This part of the API is called the REL-ID Advanced API. The rest of the interactions are applicable regardless (ie part of the Basic API). In other words, the Advanced API is nothing but the Basic API + User-Identity interaction.
</aside>

## Initialization

This interaction is governed by a single API routine (```Initialize```) invocation that sets the stage for all subsequent interactions. 

Most importantly, this is the phase when the <u>API runtime establishes an agent-authenticated session with the REL-ID platform</u> backend and <u>bootstraps the DNA for subsequent connectivity with both REL-ID platform services as well as the configured backend enterprise services</u>

The following information is supplied by the API-client application to the initialization routing:

 * Agent information (available as a base64-encoded blob, upon provisioning a new agent REL-ID on a commercially licensed REL-ID Gateway Manager)
 * Callback methods/functions that the API runtime will use to communicate with the API-client application (status/error notifications, device context/fingerprint retrieval)
 * Network coordinates of the REL-ID Authentication Gateway (hostname/IP address and port number)
 * Privacy (encryption) specifications for the Session-Scope - includes cipher specs and salt to use
 * Opaque reference to the API-client application context (never interpreted/modified by the API runtime, placeholder for application)
 * <i>If applicable</i>, proxy information for connecting through to the REL-ID Auth Gateway

<aside class="notice"><i>The <b><u>API-runtime Context</u></b></i> -
<li>While the ```Initialize``` API routine returns immediately, it returns an opaque pointer to the API-runtime context which must be supplied with every subsequent call to the API routines. Initialization of this returned context continues, and progress is notified to the API-client via ```StatusUpdate``` invocations referring to the same API-runtime context.
<li>Note that the same API-client application process/instance can create multiple API-runtime contexts (via multiple ```Initialize``` routine calls) to communicate with different enterprise backend service zones. However, note that this type of usage can fail if the REL-ID platform backend is not appropriately configured.
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
<br>The user-identity interaction is accessible to the API-client via an additional set of API routines that build on top of the Basic API. Alongwith the Basic API routines, these additional API routines constitute the <b>REL-ID Advanced API</b>
</aside>

## Access

Upon successful initialization/authentication, the ports and facades for the access to different backend enterprise services are provided to the API-runtime to setup the DNA for API-client. This information is returned to the API-runtime everytime it creates a REL-ID session - which is adter successful initialization (PRIMARY session) and after successful end-user authentication (SECONDARY session). 

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

The terminate API routime should be called during application shutdown in order to cleanly terminate the API runtime.

# Structures and Enumerations

The following subsections list down and explain the different data structures and enumerations that are provided by the REL-ID API. The API-client application developer requires to be familiar with these in order to make effective use of the REL-ID API.

## Callback routines

This structure is supplied to the Initialize routing containing API-client application callback routines. These callback routines are invoked by the API runtime at different points in its execution - for updating status, for requesting the API-client application to supply information etc.

There are 3 primary callback routines that are provided - 2 of them are part of the Basic API and 1 of them is part of the Advanced API.

```c
/* Callback invoked by core API runtime to update API-client of state changes, exceptions and notifications */
typedef
int 
(*fn_status_update_t)
(core_status_t* pStatus);

/* Callback invoked by core API runtime to retrieve device fingerprint identity information */
typedef
int
(*fn_get_device_fingerprint_t)
(char **psDeviceFingerprint, void* pvAppCtx);

/* Callback invoked by core API runtime to unpack the 'locked' end-user RelID received post successful end-user authentication */
typedef
int
(*fn_unpack_enduser_relid_t)
(char* euRelId,
 char** uRelId);

/* struct of callback pointers */
typedef struct {
  fn_status_update_t          pfnStatusUpdate;
  fn_get_device_fingerprint_t pfnGetDeviceFingerprint;
  fn_unpack_enduser_relid_t   pfnUnpackEndUserRelId;
} core_callbacks_t;
```

```java
/* TODO: */
public class RDNA {
  //...
  public interface RDNACallbacks {
    public int onInitializeCompleted(RDNAStatus status);
    public String unpackEndUserRelID (String euRelId);
    public Object getDeviceContext();
    public String getApplicationFingerprint();
    public void onStartService(List<RDNAService> serviceList);
    public void onStopeService(List<RDNAService> serviceList);
    public void onTerminated(RDNAStatus status);
    public void onPauseRuntime(RDNAStatus status);
    public void onResumeRuntime(RDNAStatus status);
  }
  //...
}
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Callback Routine | Basic/Advanced | Description
---------------- | ---------------| -----------
<b>StatusUpdate</b> | Basic API | Invoked by the API runtime in order to update the API-client application of the progress of a previously invoked API routine, or state changes and exceptions encountered in general during the course of its execution
<b>GetDeviceFingerprint</b> | Basic API (core/ANSI-C) | Invoked by the API runtime during initialization (session creation) in order to retrieve the fingerprint identity of the end-point device
<b>GetDeviceContext</b> | Basic API (Java/Obj-C/C++) | Invoked by the API runtime during initialization (session creation) in order to retrieve the device context reference to be able to determine the fingerprint identity of the end-point device
<b>GetAppFingerprint</b> | Basic API (Java/Obj-C/C++) | Invoked by the API runtime during initialization (session creation) in order to retrieve the application fingerprint, supplied by the API-client application to include in the device details.<br>The intent of this routine is to provide the application with an opportunity to checksum itself so that the backend can check integrity of the application.
<b>UnpackEndUserRelId</b> | Advanced API | Invoked by the API runtime after successful user credential authentication, in order to unpack the <i>locked</i> user Rel-ID as received from the REL-ID platform backend.

Apart from the above callback routines, specific events have been called out as onThisHappened() and onThatHappened() callbacks, in the wrapper APIs. This is to make it simpler and clearer for the API-client to react to these events.

<aside class="notice"><i><b><u>GetDeviceFingerprint</u></b> and <b><u>GetDeviceContext</u></b> callback routines</i> -
<br>
<u>GetDeviceFingerprint</u> is the callback defined in the ANSI C core API, while
<br>
<u>GetDeviceContext</u> is the callback defined in the end-point platform specific wrapper APIs - Android (Java), iOS (Objective C) and WindowsPhone (C++)
</aside>

## Proxy settings

This structure is supplied to the Initialize routine when the REL-ID Auth Gateway is accessible only from behind an HTTP proxy. For example, when using a REL-ID-integrated application from a device, when connected to a corporate intranet, where connectivity to internet is only via the corporate proxy.

Hence this structure is an option input parameter to Initialize, and may not always require to be supplied. The API-client application requires to keep track of whether or not this needs to be supplied during initialization - for example by providing a 'connect profile settings' screen for the end-user.

At an abstract level, the pieces of information supplied by this data structure are:

```c
typedef struct {
  char* sProxyHNIP;
  int   nProxyPORT;
  char* sUsername;
  char* sPassword;
} proxy_settings_t;
```

```java
public class RDNA {
  //...
  public static class ProxySettings {
    String proxyHNIP;
    int    proxyPORT;
    String username;
    String password;
  }
  //...
}
```

```objective_c
@interface ProxySettings : NSObject
@property(nonatomic,copy) NSString *proxyHNIP;
@property(nonatomic)      int       proxyPORT;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *password;
@end
```

```cpp
/* TODO: */
```

Field | Description
----- | -----------
<b>ProxyHNIP</b> | <b>H</b>ost<b>N</b>ame or <b>IP</b> address of the proxy server
<b>ProxyPORT</b> | Port number of the proxy server
<b>ProxyUsername</b> | The username to use to authenticate with the proxy server. This is required only when the proxy server requires authentication.
<b>ProxyPassword</b> | The password to use with the username, to authenticate with the proxy server. This too is required only when the proxy server requires authentication.

## Status update

This structure is supplied to the API-client supplied ```StatusUpdate``` callback routine when it is invoked from the API runtime. This structure covers all possible statuses that the API runtime would notify the API-client application about.

At an abstract level, the pieces of information supplied by this data structure are:

```c
typedef struct {
  union {
    struct {
      core_service_t** pServices;
      int              nServices;
    } initialize;
    char errorDesc[1024];
  } u;
} core_args_t;

typedef struct {
  void* pvCoreCtx;    /* context of API runtime */
  void* pvAppCtx;     /* context of API-client  */
  e_core_method_t eMethId; /* update for method */
  int  errId;              /* error code return */
  core_args_t* pArgs;      /* status details    */
} core_status_t;
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Field | Description
----- | -----------
<b>RDNAContext</b> | A reference to the DNA context returned upon successful ```Initialize``` routine invocation. Note that there can technically be multiple such contexts active in the same API-client application - it depends on the application and its purpose.
<b>APIClientContext</b> | An opaque reference to the API-client supplied context. This is supplied by the API-client to the ```Initialize``` routine, and is associated with the REL-ID DNA context throughout its lifetime. Note that this context is never read/interpreted or modified by the API runtime.
<b>MethodIdentifier</b> | An identifier that specifies which method was invoked by the API-client application.
<b>ErrorIdentifier</b> | An identifier that specifies the nature of the error that is being reported in the status update.
<b>StatusArguments</b> | This is a polymorphic reference to status information - the actual reference to use depends on the method and error identifiers. For example in ANSI C, this points to a ```union```-based structure, and in Java this points to an ```Object``` reference that must be typecast accordingly.

## Error codes (enum)

<aside class="warning"><i><b><u>TODO: This table as well as the code-blocks need to be updated</u></b></i></aside>

```c
/* TODO: */
typedef enum {
  //Common error codes
  CORE_ERR_NONE = 0,          /* No Error */
  CORE_ERR_NULLCONTEXTPTR,    /* Null context ptr passed in */
  CORE_ERR_INVALIDPARAMETERS, /* Invalid Parameter passed in */
  CORE_ERR_NOMEMORY,          /* Memory allocation failed */

  CORE_ERR_NULLCALLBACKS,   /* Null callback/ptr passed in */
  CORE_ERR_NULLEMPTYHNIP,   /* Null or empty hostname/IP */
  CORE_ERR_INVALIDPORTNUM,  /* Invalid port number */
  CORE_ERR_EVENTLOOPINIT,   /* Failed to start event loop */
  CORE_ERR_MUTEXINITFAILED, /* Failed to initialize mutex */
  CORE_ERR_EVENTINITFAILED, /* Failed to initialize event */
  CORE_ERR_THRDSTARTFAILED, /* Failed to start thread */
  CORE_ERR_BADDNACONFIG,    /* Bad DNA configuration (tunnelconfig) */
  CORE_ERR_DNANOTRUNNING,   /* DNA is not running */
  CORE_ERR_ACCESSPORTISUP,  /* Access port has been started */
  CORE_ERR_ACCESSPORTISDOWN,/* Access port has been stopped */
  CORE_ERR_CORRUPTSTATEBUF, /* State buffer passed into ResumeRuntime is corrupt */
  CORE_ERR_INVALIDJSON,

  //Core Crypto error codes
  CORE_ERR_INVALIDCIPHERSPECS = 101, /* Invalid cipher-specifications */
  CORE_ERR_INVALIDCIPHERKEY,
  CORE_ERR_INVALIDPRIVACYSCOPE,
  CORE_ERR_CIPHERREGISTERFAILED,
  CORE_ERR_CIPHEROPERATIONFAILED,
  CORE_ERR_CIPHERKEYSALTINGFAILED,
  CORE_ERR_DIGESTREGISTERFAILED,
  CORE_ERR_DIGESTOPERATIONFAILED,
  CORE_ERR_CIPHERTEXTNOTMULTIPLEOFBLOCKSIZE,
  CORE_ERR_DATAINTEGRITYCHECKFAILED,
  CORE_ERR_INVALIDDATAPACKETLENGTH,
  CORE_ERR_INVALIDSTREAMTYPE,
  CORE_ERR_INVALIDBLOCKSIZE,
  CORE_ERR_INVALIDREADYREADSIZE,

  //Encoding decoding failure
  CORE_ERR_DATAENCODINGFAILED,
  CORE_ERR_DATADECODINGFAILED,

  //Http parser formatter failure
  CORE_ERR_HTTPPARSERINITFAILED,
  CORE_ERR_HTTPPARSEROPERARTIONFAILED,
  CORE_ERR_HTTPFORMATTERINITFAILED,
  CORE_ERR_HTTPFORMATTEROPERARTIONFAILED,

  CORE_ERR_AGENTRELIDNOTFOUND,
  CORE_ERR_TUNNELLEDLISTEMPTY,
  CORE_ERR_INVALIDTUNNELLCONFIG,
  CORE_ERR_INVALIDAGENTINFO,
  CORE_ERR_INVALIDARGS,                        /* Invalid arguments specified for the routine */
  CORE_ERR_FAILEDTOINTIALIZE,

  //Get Service Error Codes
  CORE_ERR_SERVICECONTAINERISNULL,
  CORE_ERR_SERVICECONTAINERISEMPTY,
  CORE_ERR_SERVICENOTFOUND,
  CORE_ERR_SERVICE_ALREADY_STARTED,
  CORE_ERR_FAILED_TO_START_SERVICE,

  CORE_ERR_PAUSESERIALIZEFAILED,

  //Parse Session Ticket Error Codes
  CORE_ERR_SESSIONTICKETJSONISINVALID,

  //Get Session Blob Error Codes
  CORE_ERR_ACCESSSESSIONBLOBARRAYISNULL,
  CORE_ERR_ACCESSSESSIONBLOBARRAYISEMPTY,
  CORE_ERR_ACCESSSESSIONBLOBGATEWAYNAMEISNULL,
  CORE_ERR_ACCESSSESSIONBLOBISNULL,
  CORE_ERR_ACCESSHNIPPORTNOTFOUND,

  //Non tunnel audit log failure
  CORE_ERR_NONTUNNELAUDITLOGISNULL,
  CORE_ERR_NONTUNNELAUDITLOGISEMPTY,

  //Start stop service error codes
  CORE_ERR_SERVICECOORDINATEISNULL,
  CORE_ERR_FAILEDTOSTOPCOORDINATE,

} e_core_error_t;
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Error Code | Meaning
---------- | -------
CORE_ERR_NONE (0) | No Error
CORE_ERR_NULLCONTEXTPTR | Null context ptr passed in
CORE_ERR_NULLCALLBACKS | Null callback/ptr passed in
CORE_ERR_NULLEMPTYHNIP | Null or empty hostname/IP
CORE_ERR_INVALIDPORTNUM | Invalid port number
CORE_ERR_NOMEMORY | Memory allocation failed
CORE_ERR_EVENTLOOPINIT | Failed to start event loop
CORE_ERR_MUTEXINITFAILED | Failed to initialize mutex
CORE_ERR_EVENTINITFAILED | Failed to initialize event
CORE_ERR_THRDSTARTFAILED | Failed to start thread
CORE_ERR_BADDNACONFIG | Bad DNA configuration (tunnelconfig)
CORE_ERR_DNANOTRUNNING | DNA is not running
CORE_ERR_ACCESSPORTISUP | Access port has been started
CORE_ERR_ACCESSPORTISDOWN | port has been stopped
CORE_ERR_CORRUPTSTATEBUF | State buffer passed into ResumeRuntime is corrupt

## Method identifiers (enum)

<aside class="warning"><i><b><u>TODO: This table as well as the code-blocks need to be updated</u></b></i></aside>

These identifiers are used to identify the routine when the ```StatusUpdate``` callback routine is invoked.

```c
typedef enum {
  CORE_METH_NONE = 0,       /* Not a method ID - invalid value */
  CORE_METH_INITIALIZE,     /* The Initialize() API routine */
  CORE_METH_SVC_AXS_START,  /* The ServiceAccessStart() API routine */
  CORE_METH_SVC_AXS_STOP,   /* The ServiceAccessStop() API routine */
  CORE_METH_TERMINATE,      /* Terminate runtime */
  CORE_METH_RESUME,         /* Resume runtime */
  CORE_METH_PAUSE,          /* Pause runtime */
} e_core_method_t;
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

<aside class="warning"><i><b><u>TODO: This table as well as the code-blocks need to be updated</u></b></i></aside>

Method ID | Meaning
--------- | -------
CORE_METH_NONE (0) | Not a method ID - invalid value
CORE_METH_INITIALIZE | The ```Initialize``` API routine
CORE_METH_SVC_AXS_START | The ```ServiceAccessStart``` API routine
CORE_METH_SVC_AXS_STOP | The ```ServiceAccessStop``` API routine

## Backend services access

These structures are used with the backend service access routines. They serve to encapsulate the backend services that are accessed by the API-client application. At a high level, the following lines/bullets describe these structures -

 * Each backend service is representated as a single structure with fields identifying the following information about it -
   * its unique logical name,
   * its target backend coordinate (hostname/IP-address and port number),
   * the access-gateway to connect via, and
   * its locally available access ports
 * An opaque 'coordinate' pointer is also part of this structure, which needs to be supplied in order to stop the service access via API.
 * The access port structure in turn specifies further details such as -
   * whether the service is started or not,
   * whether the local port is bound to all device network interfaces or not,
   * whether it must be started automatically on initialization or not,
   * whether it requires local privacy (between API-client and the REL-ID DNA) or not, and finally,
   * whether it is accessible locally via a forwarded port or via the proxy facade on the DNA.

### Access Port Type flags

These flags specify attributes of the returned access port for the backend service. The meanings of each flag are as follows -

```c
/* TODO: Change source code to reflect below enum names */
typedef enum {
  CORE_PORT_PORTFWD_TYPE = 0,
  CORE_PORT_PROXY_TYPE = 1,
}e_port_type_t;
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Either one of the below flags is set in the access port structure for a service.

Flag Name | Description
--------- | -----------
CORE_PORT_PORTFWD_TYPE (0) | When set, it specifies that the access port is a locally available forwarded TCP port, representing transparent connectivity to the corresponding backend enterprise service coordinate. In this case, the API-client application would require to connect directly to this port, as if it is connecting to the backend enterprise service.
CORE_PORT_PROXY_TYPE (1) | When set, it specifies that the access port is that of the locally running proxy facade of the REL-ID DNA, which will transparently tunnel requests and connections to the corresponding backend enterprise service coordinate. In this case, the API-client applicatioj would require to assume it is accessing the backend enterprise service via a proxy server on the specified port number.

### Access Port structure

Each access port structure consists of a bit-field corresponding to a bunch of boolean flags, and the actual TCP port number for the access port.

```c
typedef struct
{
  /* TODO: change isStarted to is_started, in code */
  /* TODO: change port to port_number, in code */
  unsigned int is_started      : 1; /* access is presently enabled/running */
  unsigned int localhost_only  : 1; /* access is via only the loopback interface */
  unsigned int auto_start      : 1; /* access was started automatically on initialization */
  unsigned int privacy_enabled : 1; /* local privacy between API-client and DNA is mandatory(?) */
  unsigned int port_type       : 1; /* CORE_PORT_FORWARDING_TYPE | CORE_PORT_PROXY_TYPE */
  int port_number;                  /* local port number for accessing service */
} core_port_t;
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Field Name | Data Type | Description
---------- | --------- | -----------
is_started | bit&nbsp;(boolean) | Specifies whether the service access is enabled. In case of a PROXY_TYPE port, this implies the requests and connections to the corresponding backend enterprise service is enabled. In case of a PORTFWD_TYPE port, this implies that the locally forwarded port is up and accepting connections on behalf of the backend enterprise service.
localhost_only | bit&nbsp;(boolean) | Specifies whether the port is bound just on the local loopback interfaces. If not, it is bound on all network interfaces on the device (this is not recommended for enterprise applications)
auto_start | bit&nbsp;(boolean) | Specifies whether the service access was enabled as part of the API-runtime initialization.
privacy_enabled | bit&nbsp;(boolean) | Specifies whether use of the REL-ID Privacy API routines is mandated, for the data in transit between the API-client application and the REL-ID DNA
port_type | bit&nbsp;(boolean) | Specifies whether the port is of PROXY_TYPE (1) or PORTFWD_TYPE (0)
port_number | bit&nbsp;(boolean) | Specifies the actual TCP port number for this service access (could be PROXY or Forwarded Port)

### Service structure

The service structure is unique for a given backend service, and specifies the unique logical name, target coordinates (hostname/IP and port number), access gateway details through which to access the service and access port details. It also specifies an opaque coordinate structure to be used when operating on the service using the ServiceAccess* API routines.

```c
typedef struct
{
  char* serviceName;       /* logical service name         */
  char* targetHNIP;        /* backend hostname/IP          */
  int   targetPORT;        /* backend port number          */
  char* accessServer;      /* access server name           */
  void* serviceCoord;      /* Service coordinate structure */
  core_port_t portInfo;    /* proxy port setting           */
} core_service_t;
/* TODO: Change accessServer to access_gateway */
/* TODO: Change serviceCoord to service_ctx(?) */
/* TODO: Rename all parameters using an abc_xyz_tuv naming convension, as appropriate for C variables? */
```

```java
/* TODO: */
```

```objective_c
/* TODO: */
```

```cpp
/* TODO: */
```

Field Name | Data Type | Description
---------- | --------- | -----------
service_name | null-terminated string | Unique logical name of the backend service (as configured in REL-ID configuration (using Gateway Manager)
target_hnip | null-terminated string | The notional hostname/IP-address of the TCP coordinate of the backend service
target_port | integer | The notional port number of the TCP coordinate of the backend service
access_gateway | null-terminated string | Unique logical name of the Access Gateway through which this service is accessible
service_ctx | opaque-reference | Opaque context reference to be used when starting/stoping the ServiceAccess via the API routines
port_info | access port structure | The access port structure corresponding to the proxy facade of the DNA

# Basic API

## Initialize Routine

This is the first routine that must be called to bootstrap the REL-ID API runtime up. The arguments to this routine are descibed in the below table.

This routine starts up the API runtime (including a DNA - <i>Digital Network Adapter</i> - instance), and in the process registers the API-client supplied callback routines with the API runtime context. This is a non-blocking routine, and when it returns, it will have initiated the process of creation of a REL-ID session in PRIMARY state, using the supplied <i>agent information</i> - the progress of this operation is notified to the API-client application via the status update (core API), and event notification (wrapper API), callback routines supplied.

A reference to the context of the newly created API runtime is returned to the API-client.

```c
int
coreInitialize
(void** ppvCoreCtx,
 char*  sAgentInfo,
 core_callbacks_t*
        pCallbacks,
 char*  sAuthGatewayHNIP,
 int    nAuthGatewayPORT,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 void*  pvAppCtx,
 proxy_settings_t*
        pProxySettings);
```

```java
/* TODO */
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```
<aside class="warning"> TODO If this entire table needs to be changed, please do so </aside>

Argument&nbsp;[in/out] | Language Binding | Prototype/Description
----------------- | ----------------- | ---------
API&nbsp;Context&nbsp;[out] | ANSI C | ```void** ppvCoreCtx```<br><li>Must be non-null<br><li>```(*ppvCoreCtx)``` is updated with opaque pointer to internal API runtime context
&nbsp; | Java | An instance of ```RDNA``` is returned by the routine
&nbsp; | Objective C | TODO - what is returned
&nbsp; | C++ | TODO - what is returned
&nbsp; | <u>Description</u> | <b>Newly created API runtime context is returned to API-client application</b>
Agent&nbsp;Info&nbsp;[in] | ANSI C | ```char* sAgentInfo```
&nbsp; | Java | ```String sAgentInfo```
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Software identity information for the API-runtime to authenticate and establish primary session connectivity with the REL-ID platform backend</b>
Callbacks&nbsp;[in] | ANSI C | ```core_callbacks_t* pCallbacks```
&nbsp; | Java | ```RDNA.Callbacks&nbsp;callbacks```<br>i.e. an implementation of the ```RDNA.Callbacks``` interface
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>API-client application supplied callback routines to be invoked by the API-runtime</b>
Auth&nbsp;Gateway Coordinate&nbsp;[in] | ANSI C | ```char* sAuthGatewayHNIP```<br>```int nAuthGatewayPORT```
&nbsp; | Java | ```String sAuthGatewayHNIP```<br>```int nAuthGatewayPORT```
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Hostname/IP-address of the REL-ID Authentication Gateway against which the API-runtime must establish mutual authenticated connectivity on behalf of the API-client application</b>
Session&nbsp;Scope&nbsp;Privacy&nbsp;Details[in] | ANSI C | ```char* sCipherSpecs```<br>```char* sCipherSalt```
&nbsp; | Java | ```String sCipherSpecs```<br>```String sCipherSalt```
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>The session-scope cipher specs (encryption algorithm, padding and cipher mode), and the salt/IV to use with the cipher</b>
Application Context&nbsp;[in] | ANSI C | ```void* pvAppCtx```
&nbsp; | Java | ```Object appCtx```
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Opaque reference to API-client application context that is never interpreted/modified by the API-runtime. This reference is supplied with each callback invocation to the API-client</b>
Proxy Settings [in] | ANSI C | ```core_proxy_settings_t pProxySettings```
&nbsp; | Java | ```RDNA.ProxySettings proxySettings```
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Hostname/IPaddress and port-number for proxy to use when connecting to the Auth Gateway server. This is an optional parameter that may be null if it is not applicable</b>

<aside class="notice"><b><u>Session-Scope Cipher Details</u></b> -
<br>
The way in which session-scope privacy works is as follows:
<li>The API-client application invokes an ```Encrypt``` API routine with <i>Session</i> privacy scope and sends the encrypted data via an access port
<li>The DNA receives the data and decrypts it, before sending the data across to the backend service
<li>The DNA receives the response from the backend service, and encrypts it before sending it back to the API-client application
<li>The API-client application receives the encrypted response, and subsequently invokes a ```Decrypt``` API routine  with <i>Session</i> privacy scope before processing the plaintext response.
The cipher details supplied in the ```Initialize``` routine, sets the cipher specs and salt for use in the above interactions.
<br>
<b><i>Hence, when ```Session``` privacy scope is used with any of the ```Encrypt```/```Decrypt``` API routines, the cipher specs and salt supplied are ignored</i></b>
</aside>

## Access Routines

These routines enable the API-client applications to retrieve the service structure for the backend enterprise service it requires to interact with, and use that information to safely interact with them.
 * The first 2 ```GetService...``` routines help retrieve the service information for the service - one of them looks it up using a logical unique name of the backend service and the other retrieves all available services for the current context
 * The second 2 ```ServiceAccess...``` routines are used to start/enable and stop/disable the access to the backend services.

```c
/* TODO */
e_core_error_t
coreGetServiceByServiceName
(void*  pvCoreCtx,
 char*  sServiceName,
 core_service_t**
        ppService);

e_core_error_t
coreGetAllServices
(void*  pvCoreCtx,
 core_service_t**
        ppServices);

e_core_error_t
coreServiceAccessStart
(void*  pvCoreCtx,
 core_service_t*
        pService);

e_core_error_t
coreServiceAccessStop
(void*  pvCoreCtx,
 core_service_t*
        pService);
```

```java
/* TODO */
package com.uniken.rdna;
class RDNA {
  //
  //...
  //
  public abstract Service   GetServiceByServiceName (String serviceName);
  public abstract Service[] GetAllServices          ();
  public abstract boolean   ServiceAccessStart (Service svc);
  public abstract boolean   ServiceAccessStop  (Service svc);
  //
  //...
  //
}
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```

Routine&nbsp;Name | Description
----------------- | -----------
<b>GetServiceByServiceName</b> | Retrieve the ```Service``` structure by looking up the unique logical name of the backend service (as configured in the REL-ID Gateway Manager
<b>GetAllServices</b> | Retrieve the ```Service``` structures for all available services that are accessible via the current API-runtime context and the session within.
<b>ServiceAccessStart</b> | Access to the service (i.e. the corresponding backend enterprise service) via the access port for the ```Service``` is started<li>In case of ```PROXY_TYPE``` port, the proxy facade of the DNA in the API-runtime listening on that port will start <i>tunneling</i> requests/data to the corresponding backend service.<li>In case of ```PORTFWD_TYPE``` port, the corresponding forwarded TCP port is started in the DNA in the API-runtime, and made ready to accept connections from which data will be transparently forwarded to the corresponding backend service.
<b>ServiceAccessStop</b> | Access to the service (i.e. the corresponding backend enterprise service) via the access port for the ```Service``` is stopped<li>In case of ```PROXY_TYPE``` port, the proxy facade of the DNA in the API-runtime listening on that port will stop <i>tunneling</i> requests/data to the corresponding backend service - it will instead revert with an appropriate HTTP Proxy error code<li>In case of ```PORTFWD_TYPE``` port, the corresponding forwarded TCP port is shutdown and closed in the DNA in the API-runtime, and connections to that port will no longer be accepted.

## Data Privacy Routines

The data privacy provided to the API-client application, is delivered at different scopes - each scope sets how the privacy (encryption) keys are generated and used. Further, 3 types of encryption/decryption functionality is provided - across all supported privacy scopes -
 # Raw Data Packets: Encryption and decryption of raw data packets
 # HTTP Requests and Responses: Encryption of HTTP requests and decryption of HTTP responses
 # Buffered Streams: An in-memory buffered stream abstraction for encryption and decryption

### Data Privacy Scopes

```c
typedef enum {
  RDNA_PRIVACY_SCOPE_SESSION = 0x01, /* use session-specific keys */
  RDNA_PRIVACY_SCOPE_DEVICE  = 0x02, /* use device-specific keys  */
  RDNA_PRIVACY_SCOPE_USER    = 0x03, /* use user-specific keys    */
  RDNA_PRIVACY_SCOPE_AGENT   = 0x04, /* use agent-specific keys   */
} e_rdna_privacy_scope_t;
```

```java
package com.uniken.rdna;
class RDNA {
  //...
  public static enum ePrivacyScope {
    RDNA_PRIVACY_SCOPE_SESSION (1), /* use session-specific keys */
    RDNA_PRIVACY_SCOPE_DEVICE,      /* use device-specific keys  */
    RDNA_PRIVACY_SCOPE_USER,        /* use user-specific keys    */
    RDNA_PRIVACY_SCOPE_AGENT;       /* use agent-specific keys   */
    public final int value;
    public ePrivateScope (int valueIn) {value = valueIn;}
  }
  //...
}
```

```objective_c
@interface RDNA_ObjC : NSObject
typedef NS_ENUM(NSInteger, e_rdna_privacy_scope_t) {
  RDNA_PRIVACY_SCOPE_SESSION = 0x01, /* use session-specific keys */
  RDNA_PRIVACY_SCOPE_DEVICE  = 0x02, /* use device-specific keys  */
  RDNA_PRIVACY_SCOPE_USER    = 0x03, /* use user-specific keys    */
  RDNA_PRIVACY_SCOPE_AGENT   = 0x04, /* use agent-specific keys   */
};
@end
```

Scope | Description
----- | -----------
RDNA_PRIVACY_SCOPE_SESSION | Keys used are specific to the REL-ID session and valid for duration of the session.<br>Used to secure the privacy of data in transit between the API-client application and the REL-ID DNA, as well as between the API-client application and its backend services.<br>Cipher details for this scope is ALWAYS set during initialization (see ```Initialize``` routine documentation above)
RDNA_PRIVACY_SCOPE_DEVICE | Keys used are specific to the end-point device.<br>Used by the API-client application to secure the privacy of persistent data that the API-client application would store on the device.
RDNA_PRIVACY_SCOPE_USER | Keys used are specific to the authenticated user-identity.<br>This is relevant ONLY when the Advanced API (User-Interaction) is used.
RDNA_PRIVACY_SCOPE_AGENT | Keys used are specific to the agent (i.e. the application using the API)

### Raw Data Packets

```c
e_rdna_error_t
rdnaEncryptDataPacket
(void*  pvRdnaCtx,
 e_rdna_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 void*  pvPacketPlainBuf,
 int    nPacketPlainSize,
 void** ppvPacketEncryptedBuf,
 int*   pnPacketEncryptedSize);

e_rdna_error_t
rdnaDecryptDataPacket
(void*  pvRdnaCtx,
 e_rdna_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 void*  pvPacketEncryptedBuf,
 int    nPacketEncryptedSize,
 void** ppvPacketPlainBuf,
 int*   pnPacketPlainSize);
```

```java
package com.uniken.rdna;
class RDNA {
  //...
  public abstract byte[] EncryptDataPacket (
      ePrivacyScope scope,
      String cipherSpecs,
      String cipherSalt,
      byte[] dataPacketPlain);
  public abstract byte[] DecryptDataPacket (
      ePrivacyScope scope,
      String cipherSpecs,
      String cipherSalt,
      byte[] dataPacketEncrypted);
  //...
}
```

```objective_c
@interface RDNA_ObjC : NSObject
-(e_rdna_error_t)rdnaEncryptDataPacket:(void*)pvRdnaCtx
             ande_rdna_privacy_scope_t:(e_rdna_privacy_scope_t)ePrivScope
                       andsCipherSpecs:(NSString*)sCipherSpecs
                        andsCipherSalt:(NSString*)sCipherSalt
                   andpvPacketPlainBuf:(void*)pvPacketPlainBuf
                   andnPacketPlainSize:(int)nPacketPlainSize
              andppvPacketEncryptedBuf:(void**)ppvPacketEncryptedBuf
              andpnPacketEncryptedSize:(int*)pnPacketEncryptedSize;

-(e_rdna_error_t)rdnaDecryptDataPacket:(void*)pvRdnaCtx
             ande_rdna_privacy_scope_t:(e_rdna_privacy_scope_t)ePrivScope
                       andsCipherSpecs:(NSString*)sCipherSpecs
                        andsCipherSalt:(NSString*)sCipherSalt
               andpvPacketEncryptedBuf:(void*)pvPacketEncryptedBuf
               andnPacketEncryptedSize:(int)nPacketEncryptedSize
                  andppvPacketPlainBuf:(void**)ppvPacketPlainBuf
                  andpnPacketPlainSize:(int*)pnPacketPlainSize;
@end
```

Routine | Description
------- | -----------
<b>EncryptDataPacket</b> | <li>Raw plaintext (unencrypted) data is supplied as a buffer of bytes.<li>This data is encrypted using keys as per specified privacy scope, and returned to calling API-client application.
&nbsp; | <b><u>```rdnaEncryptDataPacket```</u></b> (ANSI C) -<li>If the supplied ```ppvPacketEncryptedBuf``` and ```pnPacketEncryptedSize``` are non-null, they are used to store the encrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)
&nbsp; | <b><u>```EncryptDataPacket```</u></b> (Java) -<li>The output is always returned as a newly allocated ```byte[]``` array/buffer
<b>DecryptDataPacket</b> | <li>Encrypted data is supplied as a buffer of bytes.<li>This data is decrypted using keys as per specified privacy scope, and returned to calling API-client application.
&nbsp; | <b><u>```rdnaDecryptDataPacket```</u></b> (ANSI C) -<li>If the supplied ```ppvPacketPlainBuf``` and ```pnPacketPlainSize``` are non-null, they are used to store the decrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)<li>Recommended method is to supply input encrypted buffer itself in these output parameters, since it will definitely be larger than or equal to what would be required to store the decrypted output. Moreover, if this is not done, the routine will not reuse the input encrypted buffer by itself
&nbsp; | <b><u>```DecryptDataPacket```</u></b> (Java) -<li>The output is always returned as a newly allocated ```byte[]``` array/buffer

<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, these routines ignore the supplied cipher details (specs and salt). This is because for the session scope the cipher details are specified while initializing the API runtime (remember?)
</aside>

### HTTP Requests and Responses

```c
e_rdna_error_t
rdnaEncryptHttpRequest
(void*  pvRdnaCtx,
 e_rdna_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 char*  sHttpRequestPlainBuf,
 int    nHttpRequestPlainSize,
 char** psHttpRequestEncryptedBuf,
 int*   pnHttpRequestEncryptedSize);

e_rdna_error_t
rdnaDecryptHttpResponse
(void*  pvRdnaCtx,
 e_rdna_privacy_scope_t
        ePrivScope,
 char*  sCipherSpecs,
 char*  sCipherSalt,
 char*  sHttpResponseEncryptedBuf,
 int    nHttpResponseEncryptedSize,
 char** psHttpResponsePlainBuf,
 int*   pnHttpResponsePlainSize);
```

```java
package com.uniken.rdna;
class RDNA {
  //...
  public abstract byte[] EncryptHttpRequest (
      ePrivacyScope scope,
      String cipherSpecs,
      String cipherSalt,
      byte[] httpRequestPlain);
  public abstract byte[] DecryptHttpResponse (
      ePrivacyScope scope,
      String cipherSpecs,
      String cipherSalt,
      byte[] httpResponseEncrypted);
  //...
}
```

```objective_c
@interface RDNA_ObjC : NSObject
-(e_rdna_error_t)rdnaEncryptHttpRequest:(void*)pvRdnaCtx
              ande_rdna_privacy_scope_t:(e_rdna_privacy_scope_t)ePrivScope
                        andsCipherSpecs:(NSString*)sCipherSpecs
                         andsCipherSalt:(NSString*)sCipherSalt
                andsHttpRequestPlainBuf:(NSString*)sHttpRequestPlainBuf
               andnHttpRequestPlainSize:(int)nHttpRequestPlainSize
           andpsHttpRequestEncryptedBuf:(NSString**)psHttpRequestEncryptedBuf
          andpnHttpRequestEncryptedSize:(int*)pnHttpRequestEncryptedSize;

-(e_rdna_error_t)rdnaDecryptHttpResponse:(void*)pvRdnaCtx
               ande_rdna_privacy_scope_t:(e_rdna_privacy_scope_t)ePrivScope
                         andsCipherSpecs:(NSString*)sCipherSpecs
                          andsCipherSalt:(NSString*)sCipherSalt
            andsHttpResponseEncryptedBuf:(NSString*)sHttpResponseEncryptedBuf
           andnHttpResponseEncryptedSize:(int)nHttpResponseEncryptedSize
               andpsHttpResponsePlainBuf:(NSString**)psHttpResponsePlainBuf
              andpnHttpResponsePlainSize:(int*)pnHttpResponsePlainSize;
@end
```

Routine | Description
------- | -----------
<b>EncryptHttpRequest</b> | <li>HTTP request in plaintext (unencrypted) form is supplied as a buffer of bytes.<li>This request is encrypted using keys as per specified privacy scope, encoded appropriately, wrapped around in an HTTP request envelope and returned back to calling API-client application as another HTTP request.
&nbsp; | <b><u>```rdnaEncryptHttpRequest```</u></b> (ANSI C) -<li>If the supplied ```psHttpRequestEncryptedBuf``` and ```pnHttpRequestEncryptedSize``` are non-null, they are used to store the encrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)
&nbsp; | <b><u>```EncryptHttpRequest```</u></b> (Java) -<li>The output is always returned as a newly allocated ```byte[]``` array/buffer
<b>DecryptHttpResponse</b> | <li>HTTP response in encrypted form is supplied as a buffer of bytes.<li>This response is parsed, the embedded encrypted HTTP response is decoded, decrypted using keys as per specified scope, and returned back to calling API-client application as the original plaintext HTTP response.
&nbsp; | <b><u>```rdnaDecryptHttpResponse```</u></b> (ANSI C) -<li>If the supplied ```psHttpResponsePlainBuf``` and ```pnHttpResponsePlainSize``` are non-null, they are used to store the decrypted output to be returned to caller.<li>If they were null, or if they were insufficient to store the output, then memory is allocated for storing the encrypted output, and these pointers are updated with the details of the allocated memory (buffer pointer and size of buffer)<li>Recommended method is to supply input encrypted buffer itself in these output parameters, since it will definitely be larger than or equal to what would be required to store the decrypted output. Moreover, if this is not done, the routine will not reuse the input encrypted buffer by itself
&nbsp; | <b><u>```DecryptHttpResponse```</u></b> (Java) -<li>The output is always returned as a newly allocated ```byte[]``` array/buffer

<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, these routines ignore the supplied cipher details (specs and salt). This is because for the session scope the cipher details are specified while initializing the API runtime (remember?)
</aside>

### Buffered Streams

```c
/* TODO */
```

```java
/* TODO */
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```

Routine | Description
------- | -----------
<b>```fn_block_ready_t```</b> | This is a callback routine supplied by the API-client. This routine is invoked from within the ```StreamWriteInto``` routine, when the requisite number of blocks are ready for consumption by the API-client (i.e. when that many blocks have been encrypted/decrypted, depending on the type of the privacy stream
<b>CreatePrivacyStream</b> | <li>Creates a privacy stream using the supplied input - privacy scope, stream type (encryption/decryption), cipher specifications and salt, block ready callback routine and its opaque context reference, number of blocks on which to fire the block ready callback.<li><b>Privacy scope</b> - this determines which key will be used for the encryption/decryption of data written to the stream<li><b>Stream type</b> - whether the data written into the stream should be encrypted/decrypted<li><b>Cipher specs</b> - specifications of the block encryption algorithm and associated parameters to use for encrypting/decrypting data written to the stream<li><b>Cipher salt</b> - additional salt vector to be used when creating the encryption/decryption cipher<li><b>Block ready callback</b> and <b>opaque context reference</b> - callback routine to invoke when specified number blocks are read (encrypted/decrypted), along with an opaque context reference to pass when invoking it<li><b>Block ready threshold</b> - the number of ready blocks on which to invoke the block ready callback routine<li><b>[OUT] Stream reference</b> - out parameter in which the reference to the newly created privacy stream should be updated
<b>StreamGetPrivacyScope</b> | Routine to query and determine the privacy scope (app/device/user/session) of a previously created privacy stream reference
<b>StreamGetStreamType</b> | Routine to query and determine the stream type (encrypt/decrypt) of a previously created privacy stream reference
<b>StreamWriteDataInto</b> | Routine to write chunks of data into a privacy stream.<br>This routines invocation could result in the invocation of the block-ready callback routine supplied during the creation of the stream.
<b>StreamEnd</b> | Routine to terminate/end the stream - whatever unencrypted/undecrypted data is present in the stream buffers are padded and finally encrypted/decrypted.<br>This routines invocation always results in the invocation of the block-ready callback routine supplied during the creation of the stream.
<b>StreamDestroy</b> | Routine to free up the resources used for this privacy stream.


<aside class="notice"><b><u>Session Scope</u></b> -
<br>When used with session scope, these routines ignore the supplied cipher details (specs and salt). This is because for the session scope the cipher details are specified while initializing the API runtime (remember?)
</aside>


## Pause/Resume Routines

The pause and resume routines make it possible to persist the <i>in-session</i> state of the API runtime and restore the runtime from the previously persisted state.

This is useful in case of limited configuration devices and platforms - such as smartphone device platforms like Android, iOS and WindowsPhone. In these platforms, a running application could be swapped out of memory due to 'crowding' by other running applications, only to be swapped back in when the user chooses to access that application again. 

```c
/* TODO */
e_core_error_t
corePauseRuntime
(void*  pvCoreCtx,
 void** ppvState,
 int*   pnStateSize);

e_core_error_t
coreResumeRuntime
(void** ppvCoreCtx,
 void*  pvState,
 int    nStateSize,
 core_callbacks_t*
        pCallbacks);
```

```java
/* TODO */
package com.uniken.rdna;
class RDNA {
  //...
  public abstract byte[] PauseRuntime ();

  public static RDNA ResumeRuntime (
      byte[] savedState,
      Callbacks callbacks);
  //...
}
```

```objective_c
/* TODO */
@interface RDNA_ObjC : NSObject
-(e_rdna_error_t)rdnaPauseRuntime:(void*)pvRdnaCtx
                      andppvState:(void**)ppvState
                   andpnStateSize:(int*)pnStateSize;
-(e_rdna_error_t)rdnaResumeRuntime:(void**)ppvRdnaCtx
                        andpvState:(void*)pvState
                     andnStateSize:(int)nStateSize
               andrdna_callbacks_t:(id<rdna_callbacks_t>)pCallbacks;
@end
```

```cpp
/* TODO */
```

Routine | Description
------- | -----------
<b>PauseRuntime</b> | <li>State of API runtime is serialized and returned in output buffer.<li>Information in this buffer is encrypted and must be supplied <i>AS IS</i> back with the ```ResumeRuntme``` routine call.<li><b>Initiates termination/cleanup of the API-runtime before returning</b> - no ```StatusUpdate``` callback invocations are made for this API routine.
<b>ResumeRuntime</b> | <li>The supplied buffer containing a previously saved runtime state is used to re-initialize the runtime to that saved state. <li>The callback routines from the API-client must again be supplied herewith - these are not serialized by ```PauseRuntime``` since they are references to code blocks in memory and may not be valid across process re-invocations.<li>```StatusUpdate``` callback is invoked to signal completion of the re-initialization - the method ID specified is that of the ```Initialize``` API routine.

<aside class="notice"><b>It is recommended that the API-client application further encrypt this information before storing it for later retrieval and restoration into the API-runtime</b></aside>

## Terminate Routine

```c
e_dna_error_t
coreTerminate
(void*  pvCoreCtx);
```

```java
package com.uniken.rdna;
class RDNA {
  //...
  public abstract void Terminate ();
  //...
}
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```

Routine | Description
------- | -----------
<b>Terminate</b> | <li>API runtime shutdown is initiated - including freeing up memory and other resources, and stopping of the DNA.<li>No ```StatusUpdate``` callback invocations are made for this API routine

# Advanced API

The REL-ID Basic API bootstraps the REL-ID DNA with information for providing access to backend enterprise services, via the HTTP proxy and/or the forwarded TCP port facades. The REL-ID Session created during this phase is in <b>'PRIMARY'</b> state. This state represents the fact that the device has been fingerprinted and associated with a session against an application identity (Agent REL-ID).

The Advanced API, builds on top of this session, accomplishes end-user authentication, and further associates a mutually authenticated end-user to the session (which is already associated with application and device identities). At this point, the REL-ID Session is in <b>'SECONDARY'</b> state.

<aside class="notice">Note that all of the Advanced API routines may only be invoked once the Basic Initialization is successfully completed. This is because the primary function of the Advanced API is to perform end-user authentication on a previously established, valid 'PRIMARY' session</aside>

<aside class="notice">This API is designed to allow complete flexibility to the API-client application to be able to specify/conduct its own method of user-authentication. <i><u>While the built-in behaviour for these API routines in the REL-ID API and backend is specific albeit configurable, this behaviour can be customized to the needs of the enterprise application</u></i>.</aside>

The following routines constitute the REL-ID Advanced API -

Routine | Description
------- | -----------
<b>CheckUserStatus</b> | This routine submits the user identity (username/userId) to the REL-ID backend, to check its status - whether this user requires authentication on this device, what authentication to perform for this user, whether the user is blocked (on this device and/or app, or otherwise).<br>The result is one of the following - <li><b>FAILURE, &lt;reason&gt;</b><li><b>CHALLENGE, &lt;challenge&gt;</b><li><b>SUCCESS, &lt;eurelid&gt;</b><br><br>The result is informed to API-client via status update (core) / event notification (wrapper) callback routines.
<b>CheckCredentials</b> | This routine can only be invoked if a successful ```CheckUserStatus``` was performed earlier, and if that invocation reverted with a status that indicated the requirement of authentication.<br>This routine submits the user credentials (passwords, responses to challenges etc) to the REL-ID backend, to authenticate the end-user.<br>Multiple successful invocations of this routine may be needed before receiving a <b>SUCCESS, &lt;eurelid&gt;</b> result from this routine, with the same challenge (retries) and/or different challenges (additional authentication).<br>The result is one of the following - <li><b>FAILURE, &lt;reason></b><li><b>CHALLENGE, &lt;challenge&gt;</b><li><b>SUCCESS, &lt;eurelid&gt;</b><br><br>The result is informed to API-client via status update (core) / event notification (wrapper) callback routines.
<b>UpdateCredentials</b> | This routine can only be invoked if <li>a previously invoked ```CheckUserStatus``` or ```CheckCredentials``` resulted in a <b>SUCCESS, &lt;eurelid&gt;</b>,<li>which was subsequently successfully unpacked by a call to the ```UnpackEndUserRelId```,<li>after which a 'SECONDARY' session was successfully created using the unpacked UserRelId.<br><br>Pretty much all the relevant credentials of the end-user - secret question(s) and answer(s), one-time-use access code generation seeds, primary password(s), device binding to user-app etc - may be updated using this routine.<br><br>The result is informed to API-client via status update (core) / event notification (wrapper) callback routines.

## CheckUserStatus

The purpose of this routine is to check the status of the supplied end-user identity, relative to the existing agent-device binding (the 'PRIMARY' session). It could result in error (the user is blocked, the user is blocked in this agent and/or device, the user has a previous

```c
int
advCheckUserStatus
(void** ppvCoreCtx,
 char*  sUserId);
```

```java
/* TODO */
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```
Argument&nbsp;[in/out] | Language Binding | Prototype/Description
---------------------- | ---------------- | ---------------------
<b>API&nbsp;Context&nbsp;[in]</b> | ANSI C | ```void* pvCoreCtx```<br>Must be non-null, valid API runtime context reference
&nbsp; | Java | ```RDNA rdna```<br>Must be non-null, valid API runtime context reference
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Previously created and valid API runtime context reference</b>
<b>User&nbsp;Identity&nbsp;[in]</b> | ANSI C | ```char* sUserId```<br>Must be non-null, non-empty user identification
&nbsp; | Java | ```String sUserId```<br>Must be non-null, non-empty user identification
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>End-user identity information supplied as a single opaque ASCII-encoded blob (base64/...)</b><br>The API-client application can take in user identity information, via one or more fields of input used to form a structured/unstructured end-user identity - for example, [<corporate-id>.]<user-id> (internet banking), or <sol-id>.<user-id> (Finacle CBS), or <user-id>@<fqdn> / <domain>\<user-id (corporate intranet Windows domain user), etc

The following table explains the results of this API routine, which is notified to the API-client via the status update (core) / event notification (wrapper) callback routine.

Result | Description
------ | -----------
<b>FAILURE,&nbsp;&lt;reason&gt;</b> | <b>&lt;reason&gt;</b> refers an exception to be reported to the API-client.<br>For example, the system is down, disk is full, the user/dev/agent is blocked/invalid, some policy check failed etc etc etc
<b>CHALLENGE,&nbsp;&lt;challenge&gt;</b> | <b>&lt;challenge&gt;</b> is a blob containing information that the API-client application knows to process -<br><li>by displaying an appropriate challenge to the end-user operating the API-client app, with an appropriate CAPTCHA probably,<li>by accepting credential(s) in response to the challenge, and<li>by packaging the accepted credential(s) into another single opaque ASCII blob to be sent back to the AuG in a CheckCredentials API routine invocation
<b>SUCCESS,&nbsp;&lt;eurelid&gt;</b> | <b>&lt;eurelid&gt;</b> is a blob containing the '<u>encrypted UserRelId</u>' for the end-user.<li>Upon receiving this, the API-runtime invokes the ```UnpackEndUserRelId``` callback routine to allow the API-client app to decrypt and return the plaintext UserRelId to the API-runtime.<li>At this point the API-runtime will perform a full RMAK with the REL-ID backend authentication gateway using this UserRelId and attempt recreation of its session. During this session-creation request, the PRIMARY session information (ticket) as well as variant device info is submitted, for the gateway to process and revert with a 'SECONDARY' session ticket.

## CheckCredentials

The purpose of this routine is to authenticate the response (credentials) received from the end-user, after having shown him/her the challenges received from the previous ```CheckUserStatus``` or ```CheckCredentials``` routine invocation. The results from this API routine are identical in form to those of ```CheckUserStatus```

```c
int
advCheckCredentials
(void** ppvCoreCtx,
 char*  sCreds);
```

```java
/* TODO */
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```
Argument&nbsp;[in/out] | Language Binding | Prototype/Description
---------------------- | ---------------- | ---------------------
<b>API&nbsp;Context&nbsp;[in]</b> | ANSI C | ```void* pvCoreCtx```<br>Must be non-null, valid API runtime context reference
&nbsp; | Java | ```RDNA rdna```<br>Must be non-null, valid API runtime context reference
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Previously created and valid API runtime context reference</b>
<b>Credentials&nbsp;[in]</b> | ANSI C | ```char* sCreds```<br>Must be non-null, non-empty user identification
&nbsp; | Java | ```String sCreds```<br>Must be non-null, non-empty user identification
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>User-supplied credentials in the form of a single opaque ASCII-encoded blob (base64/...)</b><li>Upon receiving a <b>CHALLENGE</b> result from the ```CheckUserStatus``` API routine, the API-client application performs the actions as detailed in ```CheckUserStatus```-response(<b>CHALLENGE</b>) above.<li>The API-client displays an appropriate challenge to the end-user, with an appropriate CAPTCHA probably, accepts credential(s) in response to the challenge, packages the accepted credential(s) into a another single opaque ASCII-encoded blob and invokes this API routine.

The description of the results of this API routine is identical to those of ```CheckUserStatus``` above.

## UpdateCredentials

The purpose of this routine is to update one or more credentials of the end-user.

Hence, this routine can only be invoked if -

 * a previously invoked ```CheckUserStatus``` or ```CheckCredentials``` resulted in a <b>SUCCESS, &lt;eurelid&gt;</b>,
 * which was subsequently successfully unpacked by a call to the ```UnpackEndUserRelId```,
 * after which, a 'SECONDARY' session was successfully created by the API-runtime using the unpacked UserRelId.

```c
int
advUpdateCredentials
(void** ppvCoreCtx,
 char*  sCreds);
```

```java
/* TODO */
```

```objective_c
/* TODO */
```

```cpp
/* TODO */
```
Argument&nbsp;[in/out] | Language Binding | Prototype/Description
---------------------- | ---------------- | ---------------------
<b>API&nbsp;Context&nbsp;[in]</b> | ANSI C | ```void* pvCoreCtx```<br>Must be non-null, valid API runtime context reference
&nbsp; | Java | ```RDNA rdna```<br>Must be non-null, valid API runtime context reference
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>Previously created and valid API runtime context reference</b>
<b>Credentials&nbsp;[in]</b> | ANSI C | ```char* sCreds```<br>Must be non-null, non-empty user identification
&nbsp; | Java | ```String sCreds```<br>Must be non-null, non-empty user identification
&nbsp; | Objective C | TODO
&nbsp; | C++ | TODO
&nbsp; | <u>Description</u> | <b>User-supplied credentials in the form of a single opaque ASCII-encoded blob (base64/...)</b><li>Pretty much all the relevant credentials of the end-user - secret question(s) and answer(s), one-time-use access code generation seeds, primary password(s), device binding to user-app etc - may be updated using this routine.

The results of this API routine is just a plain <b>SUCCESS</b> or <b>FAILURE, &lt;reason&gt;</b>.


