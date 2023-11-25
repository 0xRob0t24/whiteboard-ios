TARGET = iphone:clang:latest:14
INSTALL_TARGET_PROCESSES = Whiteboard

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Whiteboard

Whiteboard_FILES = AppDelegate.swift RootViewController.swift
Whiteboard_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/application.mk
