/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/** This is generated, do not edit by hand. **/

#include <jni.h>

#include "Proxy.h"

namespace ti {
namespace keyframes {
	namespace tikeyframes {

class KeyframesProxy : public titanium::Proxy
{
public:
	explicit KeyframesProxy(jobject javaObject);

	static void bindProxy(v8::Local<v8::Object>, v8::Local<v8::Context>);
	static v8::Local<v8::FunctionTemplate> getProxyTemplate(v8::Isolate*);
	static void dispose(v8::Isolate*);

	static jclass javaClass;

private:
	static v8::Persistent<v8::FunctionTemplate> proxyTemplate;

	// Methods -----------------------------------------------------------
	static void stopAnimation(const v8::FunctionCallbackInfo<v8::Value>&);
	static void printMessage(const v8::FunctionCallbackInfo<v8::Value>&);
	static void getMessage(const v8::FunctionCallbackInfo<v8::Value>&);
	static void setMessage(const v8::FunctionCallbackInfo<v8::Value>&);
	static void startAnimation(const v8::FunctionCallbackInfo<v8::Value>&);
	static void resumeAnimation(const v8::FunctionCallbackInfo<v8::Value>&);
	static void pauseAnimation(const v8::FunctionCallbackInfo<v8::Value>&);

	// Dynamic property accessors ----------------------------------------
	static void getter_message(v8::Local<v8::Name> name, const v8::PropertyCallbackInfo<v8::Value>& info);
	static void setter_message(v8::Local<v8::Name> name, v8::Local<v8::Value> value, const v8::PropertyCallbackInfo<void>& info);

};

	} // namespace tikeyframes
} // keyframes
} // ti
