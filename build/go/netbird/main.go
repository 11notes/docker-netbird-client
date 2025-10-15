package main

import (
	"os"
	"syscall"
)

func main() {
	if _, err := os.Stat("/netbird/etc/client.json"); os.IsNotExist(err) {
		if err := syscall.Exec("/usr/local/bin/netbird", []string{"netbird", "up", "--log-file", "console", "--log-level", "warning", "--hostname", os.Getenv("NETBIRD_PEER_NAME"), "--management-url", os.Getenv("NETBIRD_URL"), "--admin-url", os.Getenv("NETBIRD_URL"), "--setup-key", os.Getenv("NETBIRD_SETUP_KEY"), "-F"}, os.Environ()); err != nil {
			os.Exit(1)
		}
	}else{
		if err := syscall.Exec("/usr/local/bin/netbird", []string{"netbird", "up", "--log-file", "console", "--log-level", "warning", "-F"}, os.Environ()); err != nil {
			os.Exit(1)
		}
	}
}