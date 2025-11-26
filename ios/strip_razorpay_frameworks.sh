#!/bin/bash

# Script to remove nested frameworks and bundles from Razorpay.framework
# This fixes App Store validation errors for nested bundles

echo "🔧 Stripping nested frameworks from Razorpay..."

RAZORPAY_FRAMEWORK="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/Razorpay.framework"

if [ -d "$RAZORPAY_FRAMEWORK" ]; then
    echo "📦 Found Razorpay.framework at: $RAZORPAY_FRAMEWORK"
    
    # Remove nested Frameworks directory
    if [ -d "$RAZORPAY_FRAMEWORK/Frameworks" ]; then
        echo "🗑️  Removing nested Frameworks directory..."
        rm -rf "$RAZORPAY_FRAMEWORK/Frameworks"
        echo "✅ Removed nested Frameworks"
    fi
    
    # Remove nested bundles (*.bundle)
    if ls "$RAZORPAY_FRAMEWORK"/*.bundle 1> /dev/null 2>&1; then
        echo "🗑️  Removing nested bundles..."
        rm -rf "$RAZORPAY_FRAMEWORK"/*.bundle
        echo "✅ Removed nested bundles"
    fi
    
    # Remove any .framework files inside
    if ls "$RAZORPAY_FRAMEWORK"/*.framework 1> /dev/null 2>&1; then
        echo "🗑️  Removing nested framework files..."
        rm -rf "$RAZORPAY_FRAMEWORK"/*.framework
        echo "✅ Removed nested frameworks"
    fi
    
    echo "✅ Razorpay.framework cleaned successfully!"
else
    echo "⚠️  Razorpay.framework not found at expected location"
fi

echo "✅ Script completed"
