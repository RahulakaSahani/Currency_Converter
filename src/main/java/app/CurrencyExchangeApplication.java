package app;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

public final class CurrencyExchangeApplication {

    private CurrencyExchangeApplication() {
    }

    public static void main(String[] args) throws Exception {
        int port = resolvePort();
        String contextPath = normalizeContextPath(System.getProperty("server.contextPath", ""));

        Path projectRoot = resolveProjectRoot();
        Path webAppDir = projectRoot.resolve("src/main/webapp");
        Path classesDir = projectRoot.resolve("target/classes");
        Path tomcatBaseDir = projectRoot.resolve("target/tomcat");

        if (!Files.isDirectory(webAppDir)) {
            throw new IllegalStateException("Cannot find web app directory: " + webAppDir);
        }

        Files.createDirectories(tomcatBaseDir);

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir(tomcatBaseDir.toString());
        tomcat.getConnector();

        Context context = tomcat.addWebapp(contextPath, webAppDir.toString());
        context.addLifecycleListener(new Tomcat.FixContextListener());
        context.setParentClassLoader(CurrencyExchangeApplication.class.getClassLoader());
        WebResourceRoot resources = new StandardRoot(context);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes", classesDir.toString(), "/"));
        context.setResources(resources);

        tomcat.start();
        String displayPath = contextPath.isEmpty() ? "/" : contextPath;
        System.out.printf("Currency Exchange Studio started at http://localhost:%d%s%n", port, displayPath);
        tomcat.getServer().await();
    }

    private static int resolvePort() {
        String systemPort = System.getProperty("server.port");
        if (systemPort != null && !systemPort.isBlank()) {
            return Integer.parseInt(systemPort.trim());
        }

        String envPort = System.getenv("PORT");
        if (envPort != null && !envPort.isBlank()) {
            return Integer.parseInt(envPort.trim());
        }

        return 8080;
    }

    private static Path resolveProjectRoot() {
        Path cwd = Paths.get("").toAbsolutePath().normalize();

        if (Files.isDirectory(cwd.resolve("src/main/webapp"))) {
            return cwd;
        }

        Path nestedProject = cwd.resolve("currency-exchange-app");
        if (Files.isDirectory(nestedProject.resolve("src/main/webapp"))) {
            return nestedProject;
        }

        Path current = cwd;
        while (current != null) {
            if (Files.isDirectory(current.resolve("src/main/webapp"))) {
                return current;
            }
            current = current.getParent();
        }

        return cwd;
    }

    private static String normalizeContextPath(String contextPath) {
        if (contextPath == null || contextPath.isBlank() || "/".equals(contextPath.trim())) {
            return "";
        }

        String normalized = contextPath.trim();
        if (!normalized.startsWith("/")) {
            normalized = "/" + normalized;
        }
        return normalized;
    }
}
