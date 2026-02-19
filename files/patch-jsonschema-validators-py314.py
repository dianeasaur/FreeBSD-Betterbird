Author: dianeasaur <4983626+dianeasaur@users.noreply.github.com>

  Change from dict for python 3.14 compatibility 

--- third_party/python/jsonschema/jsonschema/validators.py.orig	2026-02-19 08:40:42 UTC
+++ third_party/python/jsonschema/jsonschema/validators.py
@@ -875,8 +875,11 @@
             return None
         uri, fragment = urldefrag(url)
         for subschema in subschemas:
+            id = subschema["$id"]
+            if not isinstance(id, str):
+                continue
             target_uri = self._urljoin_cache(
-                self.resolution_scope, subschema["$id"],
+                self.resolution_scope, id,
             )
             if target_uri.rstrip("/") == uri.rstrip("/"):
                 if fragment:
