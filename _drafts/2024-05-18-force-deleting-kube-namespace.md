---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---
<!-- Image example
![MS-DOS Family Tree](/images/folder/filename.png){:width="700px"}
-->
<!-- Link example -->
[Link to full-size image](/images/buttons/large/ahmygod.gif)

Footnote[^1]

<details>
  <summary>One more quick hack? 🎭</summary>
  <div markdown="1">
  → Easy  
  → And simple
  </div>
</details>


<!-- Separator -->
---

[^1]: Further information here

Force-deleting a namespace

```sh
kubectl proxy --help 
Creates a proxy server or application-level gateway between localhost and the Kubernetes API server.
It also allows serving static content over specified HTTP path. All incoming data enters through one
port and gets forwarded to the remote Kubernetes API server port, except for the path matching the
static content path.

Examples:
  # To proxy all of the Kubernetes API and nothing else
  kubectl proxy --api-prefix=/
  
  # To proxy only part of the Kubernetes API and also some static files
  # You can get pods info with 'curl localhost:8001/api/v1/pods'
  kubectl proxy --www=/my/files --www-prefix=/static/ --api-prefix=/api/
  
  # To proxy the entire Kubernetes API at a different root
  # You can get pods info with 'curl localhost:8001/custom/api/v1/pods'
  kubectl proxy --api-prefix=/custom/
  
  # Run a proxy to the Kubernetes API server on port 8011, serving static content from ./local/www/
  kubectl proxy --port=8011 --www=./local/www/
  
  # Run a proxy to the Kubernetes API server on an arbitrary local port
  # The chosen port for the server will be output to stdout
  kubectl proxy --port=0
  
  # Run a proxy to the Kubernetes API server, changing the API prefix to k8s-api
  # This makes e.g. the pods API available at localhost:8001/k8s-api/v1/pods/
  kubectl proxy --api-prefix=/k8s-api

Options:
    --accept-hosts='^localhost$,^127\.0\.0\.1$,^\[::1\]$':
        Regular expression for hosts that the proxy should accept.

    --accept-paths='^.*':
        Regular expression for paths that the proxy should accept.

    --address='127.0.0.1':
        The IP address on which to serve on.

    --api-prefix='/':
        Prefix to serve the proxied API under.

    --append-server-path=false:
        If true, enables automatic path appending of the kube context server path to each request.

    --disable-filter=false:
        If true, disable request filtering in the proxy. This is dangerous, and can leave you
        vulnerable to XSRF attacks, when used with an accessible port.

    --keepalive=0s:
        keepalive specifies the keep-alive period for an active network connection. Set to 0 to
        disable keepalive.

    -p, --port=8001:
        The port on which to run the proxy. Set to 0 to pick a random port.

    --reject-methods='^$':
        Regular expression for HTTP methods that the proxy should reject (example
        --reject-methods='POST,PUT,PATCH'). 

    --reject-paths='^/api/.*/pods/.*/exec,^/api/.*/pods/.*/attach':
        Regular expression for paths that the proxy should reject. Paths specified here will be
        rejected even accepted by --accept-paths.

    -u, --unix-socket='':
        Unix socket on which to run the proxy.

    -w, --www='':
        Also serve static files from the given directory under the specified prefix.

    -P, --www-prefix='/static/':
        Prefix to serve static files under, if static file directory is specified.

Usage:
  kubectl proxy [--port=PORT] [--www=static-dir] [--www-prefix=prefix] [--api-prefix=prefix]
[options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

```


```sh
kubectl proxy --port 8886 &                                                                                      ─╯
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8886/api/v1/namespaces/$NAMESPACE/finalize
[2] 2801266
Starting to serve on 127.0.0.1:8886
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "privatebin",
    "uid": "21233f98-7262-400b-a340-8543e984787f",
    "resourceVersion": "169363807",
    "creationTimestamp": "2023-10-29T19:48:21Z",
    "deletionTimestamp": "2024-05-18T18:26:30Z",
  },
  "spec": {},
  "status": {
    "phase": "Terminating",
    "conditions": [
      {
        "type": "NamespaceDeletionDiscoveryFailure",
        "status": "True",
        "lastTransitionTime": "2024-05-18T18:26:35Z",
        "reason": "DiscoveryFailed",
        "message": "Discovery failed for some groups, 1 failing: unable to retrieve the complete list of server APIs: acme.cluster.local/v1alpha1: stale GroupVersion discovery: acme.cluster.local/v1alpha1"
      },
      {
        "type": "NamespaceDeletionGroupVersionParsingFailure",
        "status": "False",
        "lastTransitionTime": "2024-05-18T18:26:58Z",
        "reason": "ParsedGroupVersions",
        "message": "All legacy kube types successfully parsed"
      },
      {
        "type": "NamespaceDeletionContentFailure",
        "status": "False",
        "lastTransitionTime": "2024-05-18T18:26:58Z",
        "reason": "ContentDeleted",
        "message": "All content successfully deleted, may be waiting on finalization"
      },
      {
        "type": "NamespaceContentRemaining",
        "status": "False",
        "lastTransitionTime": "2024-05-18T18:26:58Z",
        "reason": "ContentRemoved",
        "message": "All content successfully removed"
      },
      {
        "type": "NamespaceFinalizersRemaining",
        "status": "False",
        "lastTransitionTime": "2024-05-18T18:26:58Z",
        "reason": "ContentHasNoFinalizers",
        "message": "All content-preserving finalizers finished"
      }
    ]
  }
}
```
