/*******************************************************************************
 * Copyright (c) 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
package org.eclipse.core.runtime.adaptor;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;

import org.eclipse.osgi.framework.adaptor.core.BundleURLConnection;
import org.eclipse.osgi.service.urlconversion.URLConverter;

/**
 * The service implementation that allows bundleresource or bundleentry
 * URLs to be converted to native file URLs on the local file system.
 */
public class URLConverterImpl implements URLConverter{

	public URL convertToFileURL(URL url) throws IOException{
		//TODO should close connection 
		URLConnection connection = url.openConnection();
		if (connection instanceof BundleURLConnection) {
			return ((BundleURLConnection)connection).getFileURL();
		}
		else {
			return url;
		}
	}

	public URL convertToLocalURL(URL url) throws IOException {
		//TODO should close connection 		
		URLConnection connection = url.openConnection();
		if (connection instanceof BundleURLConnection) {
			return ((BundleURLConnection)connection).getLocalURL();
		}
		else {
			return url;
		}
	}
}
