Author: dianeasaur <4983626+dianeasaur@users.noreply.github.com>

  Remove deprecated function call to ast.Str

--- python/mozbuild/mozbuild/frontend/reader.py.orig	2026-02-19 08:33:25 UTC
+++ python/mozbuild/mozbuild/frontend/reader.py
@@ -470,7 +470,7 @@ class TemplateFunction:
             return c(
                 ast.Subscript(
                     value=c(ast.Name(id=self._global_name, ctx=ast.Load())),
-                    slice=c(ast.Index(value=c(ast.Str(s=node.id)))),
+                    slice=c(ast.Index(value=c(ast.Constant(value=node.id)))),
                     ctx=node.ctx,
                 )
             )
@@ -1039,8 +1039,8 @@ class BuildReader:
                 else:
                     # Others
                     assert isinstance(target.slice, ast.Index)
-                    assert isinstance(target.slice.value, ast.Str)
-                    key = target.slice.value.s
+                    assert isinstance(target.slice.value, ast.Constant)
+                    key = target.slice.value.value
             elif isinstance(target, ast.Attribute):
                 assert isinstance(target.attr, str)
                 key = target.attr
@@ -1051,11 +1051,11 @@ class BuildReader:
             value = node.value
             if isinstance(value, ast.List):
                 for v in value.elts:
-                    assert isinstance(v, ast.Str)
-                    yield v.s
+                    assert isinstance(v, ast.Constant)
+                    yield v.value
             else:
-                assert isinstance(value, ast.Str)
-                yield value.s
+                assert isinstance(value, ast.Constant)
+                yield value.value

         assignments = []

--- python/mozbuild/mozbuild/vendor/rewrite_mozbuild.py.orig	2026-02-19 08:33:42 UTC
+++ python/mozbuild/mozbuild/vendor/rewrite_mozbuild.py
@@ -327,15 +327,13 @@ def assignment_node_to_source_filename_list(code, node
     """
     if isinstance(node.value, ast.List) and "elts" in node.value._fields:
         for f in node.value.elts:
-            if not isinstance(f, ast.Constant) and not isinstance(f, ast.Str):
+            if not isinstance(f, ast.Constant):
                 log(
                     "Found non-constant source file name in list: ",
                     ast_get_source_segment(code, f),
                 )
                 return []
-        return [
-            f.value if isinstance(f, ast.Constant) else f.s for f in node.value.elts
-        ]
+        return [f.value for f in node.value.elts]
     elif isinstance(node.value, ast.ListComp):
         # SOURCES += [f for f in foo if blah]
         log("Could not find the files for " + ast_get_source_segment(code, node.value))
