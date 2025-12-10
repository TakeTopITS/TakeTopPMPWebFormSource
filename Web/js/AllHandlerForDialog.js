/// 获取Cookie的函数
function getcookie(name) {
    var value = "; " + document.cookie;
    var parts = value.split("; " + name + "=");
    if (parts.length == 2) return parts.pop().split(";").shift();
}


// 在鼠标位置显示确认是否删除自定义弹窗
// 全局变量记录鼠标位置
var lastMousePosition = { x: 0, y: 0 };

// 监听鼠标移动记录位置
document.addEventListener('mousemove', function (e) {
    lastMousePosition.x = e.clientX;
    lastMousePosition.y = e.clientY;
});

// 存储当前激活的弹窗引用
var activePopup = null;

function showAlertAtMouse(message) {
    // 如果已有弹窗，先移除
    if (activePopup && activePopup.parentNode) {
        activePopup.parentNode.removeChild(activePopup);
        activePopup = null;
    }

    // 创建弹窗元素
    var popup = document.createElement('div');
    popup.innerHTML = message;
    popup.style.position = 'fixed';
    popup.style.backgroundColor = '#d4edda';
    popup.style.color = '#155724';
    popup.style.padding = '12px 16px';
    popup.style.border = '1px solid #c3e6cb';
    popup.style.borderRadius = '8px';
    popup.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
    popup.style.zIndex = '10000';
    popup.style.fontSize = '14px';
    popup.style.maxWidth = '300px';
    popup.style.wordWrap = 'break-word';
    popup.style.cursor = 'pointer';
    popup.style.transition = 'opacity 0.3s ease';

    // 尝试多种方式获取鼠标位置
    var x, y;

    // 方式1：使用全局记录的鼠标位置（适用于ClientScript.RegisterStartupScript）
    if (lastMousePosition.x > 0 && lastMousePosition.y > 0) {
        x = lastMousePosition.x - 100;
        y = lastMousePosition.y - 60;
    }
    // 方式2：如果全局位置无效，使用窗口中央位置（回退方案）
    else {
        x = (window.innerWidth - 300) / 2;
        y = (window.innerHeight - 100) / 2;
    }

    // 边界检查
    if (x < 10) x = 10;
    if (y < 10) y = 10;
    if (x + 300 > window.innerWidth) x = window.innerWidth - 310;
    if (y + 100 > window.innerHeight) y = window.innerHeight - 110;

    popup.style.left = x + 'px';
    popup.style.top = y + 'px';

    // 点击弹窗关闭
    popup.onclick = function () {
        if (popup.parentNode) {
            popup.parentNode.removeChild(popup);
            activePopup = null;
        }
    };

    document.body.appendChild(popup);
    activePopup = popup;

    // 添加显示动画
    setTimeout(function () {
        popup.style.opacity = '1';
    }, 10);

    // 3秒后自动消失（带淡出效果）
    setTimeout(function () {
        if (popup.parentNode) {
            popup.style.opacity = '0';
            setTimeout(function () {
                if (popup.parentNode) {
                    popup.parentNode.removeChild(popup);
                    activePopup = null;
                }
            }, 300);
        }
    }, 3000);
}

// 增强版：支持直接传入事件对象（适用于ScriptManager.RegisterStartupScript）
function showAlertAtMouseEx(message, event) {
    // 如果有事件对象，优先使用实时鼠标位置
    if (event) {
        lastMousePosition.x = event.clientX;
        lastMousePosition.y = event.clientY;
    }

    // 调用原有函数
    showAlertAtMouse(message);
}

// 初始化函数，确保在页面加载完成后设置初始位置
function initMouseTracker() {
    // 设置初始位置为屏幕中央
    lastMousePosition.x = window.innerWidth / 2;
    lastMousePosition.y = window.innerHeight / 2;

    // 监听页面点击事件，更新鼠标位置
    document.addEventListener('click', function (e) {
        lastMousePosition.x = e.clientX;
        lastMousePosition.y = e.clientY;
    });
}

// 页面加载完成后初始化
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMouseTracker);
} else {
    initMouseTracker();
}

// =========================== 自定义确认对话框 ===========================

// 安全的顶层文档访问函数
function getTopDocument() {
    try {
        // 尝试访问顶层文档
        if (top && top.document && !top.closed) {
            return top.document;
        }
    } catch (e) {
        // 如果由于同源策略无法访问top，使用当前文档
        console.warn('Cannot access top document, using current document:', e.message);
    }

    // 回退到当前文档
    return document;
}

// 安全的顶层窗口访问函数
function getTopWindow() {
    try {
        if (top && !top.closed) {
            return top;
        }
    } catch (e) {
        console.warn('Cannot access top window, using current window:', e.message);
    }

    return window;
}

// 在鼠标正上方显示，确保不超出页面边框
function getPositionAboveMouse(x, y, dialogWidth, dialogHeight) {
    var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
    var viewportHeight = window.innerHeight || document.documentElement.clientHeight;

    var margin = 10;
    var mouseOffset = 5; // 距离鼠标的偏移量，避免紧贴鼠标

    // 计算正上方的位置（水平居中于鼠标）
    var finalX = x - (dialogWidth / 2);
    var finalY = y - dialogHeight - mouseOffset;

    // 检查左边界
    if (finalX < margin) {
        finalX = margin;
    }

    // 检查右边界
    if (finalX + dialogWidth > viewportWidth - margin) {
        finalX = viewportWidth - dialogWidth - margin;
    }

    // 检查上边界（如果上方空间不够）
    if (finalY < margin) {
        // 上方空间不够，显示在鼠标下方
        finalY = y + mouseOffset;
    }

    // 检查下边界（如果显示在下方且空间不够）
    if (finalY + dialogHeight > viewportHeight - margin) {
        finalY = viewportHeight - dialogHeight - margin;
    }

    return { x: finalX, y: finalY };
}

// 智能对话框位置计算
function calculateDialogPosition(event, dialogWidth, dialogHeight, targetWindow) {
    var x, y;

    try {
        // 尝试获取框架在顶层窗口中的位置
        var frameElement = window.frameElement;
        if (frameElement && targetWindow !== window) {
            var frameRect = frameElement.getBoundingClientRect();
            x = event.clientX + frameRect.left;
            y = event.clientY + frameRect.top;
        } else {
            // 直接使用事件坐标
            x = event.clientX;
            y = event.clientY;
        }
    } catch (e) {
        // 如果计算失败，使用事件坐标
        x = event.clientX;
        y = event.clientY;
    }

    // 使用目标窗口的视口尺寸
    var viewportWidth = targetWindow.innerWidth || targetWindow.document.documentElement.clientWidth;
    var viewportHeight = targetWindow.innerHeight || targetWindow.document.documentElement.clientHeight;

    var margin = 10;
    var mouseOffset = 5;

    // 计算正上方的位置（水平居中于鼠标）
    var finalX = x - (dialogWidth / 2);
    var finalY = y - dialogHeight - mouseOffset;

    // 检查左边界
    if (finalX < margin) {
        finalX = margin;
    }

    // 检查右边界
    if (finalX + dialogWidth > viewportWidth - margin) {
        finalX = viewportWidth - dialogWidth - margin;
    }

    // 检查上边界（如果上方空间不够）
    if (finalY < margin) {
        // 上方空间不够，显示在鼠标下方
        finalY = y + mouseOffset;
    }

    // 检查下边界（如果显示在下方且空间不够）
    if (finalY + dialogHeight > viewportHeight - margin) {
        finalY = viewportHeight - dialogHeight - margin;
    }

    return { x: finalX, y: finalY };
}

// 初始化自定义确认对话框
function initCustomConfirm() {
    // 使用安全的顶层文档访问
    var targetDoc = getTopDocument();

    if (targetDoc.getElementById('customConfirm')) return;

    // 创建遮罩层
    var overlay = targetDoc.createElement('div');
    overlay.id = 'confirmOverlay';
    overlay.style.cssText = 'display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2147483647;'; // 使用最大z-index

    // 创建确认对话框
    var dialog = targetDoc.createElement('div');
    dialog.id = 'customConfirm';
    dialog.style.cssText = 'display:none; position:fixed; z-index:2147483647; background:white; padding:20px; border-radius:5px; box-shadow:0 2px 10px rgba(0,0,0,0.2); min-width:300px; max-width:90vw; border:1px solid #ccc;';

    // 根据当前语言设置按钮文本
    var langCode = getcookie("LangCode");
    var buttonTexts = getButtonTextByLang(langCode);

    dialog.innerHTML = `
        <div id="confirmMessage" style="margin-bottom:15px; font-size:14px; word-wrap:break-word; line-height:1.4;"></div>
        <div style="text-align:right;">
            <button id="confirmYes" type="button" style="margin-right:10px; padding:6px 20px; background:#007bff; color:white; border:none; border-radius:3px; cursor:pointer; font-size:12px;">${buttonTexts.confirm}</button>
            <button id="confirmNo" type="button" style="padding:6px 20px; background:#6c757d; color:white; border:none; border-radius:3px; cursor:pointer; font-size:12px;">${buttonTexts.cancel}</button>
        </div>
    `;

    targetDoc.body.appendChild(overlay);
    targetDoc.body.appendChild(dialog);

    console.log('Custom confirm dialog initialized in:', targetDoc === document ? 'current document' : 'top document');
}

// 隐藏自定义确认对话框
function hideCustomConfirm() {
    var targetDoc = getTopDocument();
    var dialog = targetDoc.getElementById('customConfirm');
    var overlay = targetDoc.getElementById('confirmOverlay');

    if (dialog) {
        dialog.style.display = 'none';
    }
    if (overlay) {
        overlay.style.display = 'none';
    }
}

// 绑定事件函数
function bindConfirmEvents(callback) {
    var targetDoc = getTopDocument();

    // 先移除之前的事件监听器
    var yesBtn = targetDoc.getElementById('confirmYes');
    var noBtn = targetDoc.getElementById('confirmNo');
    var overlay = targetDoc.getElementById('confirmOverlay');

    // 克隆并替换按钮来移除旧的事件监听器
    var newYesBtn = yesBtn.cloneNode(true);
    var newNoBtn = noBtn.cloneNode(true);

    yesBtn.parentNode.replaceChild(newYesBtn, yesBtn);
    noBtn.parentNode.replaceChild(newNoBtn, noBtn);

    // 绑定新的事件
    newYesBtn.onclick = function (e) {
        e.stopPropagation();
        hideCustomConfirm();
        if (typeof callback === 'function') {
            callback(true); // 用户点击了确认
        }
    };

    newNoBtn.onclick = function (e) {
        e.stopPropagation();
        hideCustomConfirm();
        if (typeof callback === 'function') {
            callback(false); // 用户点击了取消
        }
    };

    overlay.onclick = function (e) {
        e.stopPropagation();
        hideCustomConfirm();
        if (typeof callback === 'function') {
            callback(false); // 用户点击了取消
        }
    };

    // 阻止对话框内部的点击事件冒泡到遮罩层
    var dialog = targetDoc.getElementById('customConfirm');
    dialog.onclick = function (e) {
        e.stopPropagation();
    };
}

// 通用确认函数
function showCustomConfirm(message, event, onConfirmCallback) {
    // 初始化对话框
    initCustomConfirm();

    // 阻止默认行为
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    // 使用安全的文档访问
    var targetDoc = getTopDocument();
    var targetWindow = getTopWindow();

    // 设置消息
    targetDoc.getElementById('confirmMessage').textContent = message;

    // 设置对话框位置
    var dialog = targetDoc.getElementById('customConfirm');
    var overlay = targetDoc.getElementById('confirmOverlay');

    dialog.style.display = 'block';
    overlay.style.display = 'block';

    var dialogRect = dialog.getBoundingClientRect();
    var dialogWidth = dialogRect.width;
    var dialogHeight = dialogRect.height;

    if (event) {
        var position = calculateDialogPosition(event, dialogWidth, dialogHeight, targetWindow);
        dialog.style.left = position.x + 'px';
        dialog.style.top = position.y + 'px';
        dialog.style.transform = 'none';
    } else {
        // 没有鼠标事件时居中显示
        dialog.style.left = '50%';
        dialog.style.top = '50%';
        dialog.style.transform = 'translate(-50%, -50%)';
    }

    // 绑定事件
    bindConfirmEvents(onConfirmCallback);

    return false;
}

// 专门的退出确认函数 - 支持传入重定向URL
function confirmExit(message, btn, event, redirectUrl) {
    return showCustomConfirm(message, event, function (confirmed) {
        if (confirmed) {
            var targetWindow = getTopWindow();
            // 使用传入的URL执行退出操作
            if (redirectUrl) {
                targetWindow.location.href = redirectUrl;
            } else {
                targetWindow.location.href = 'Default.aspx';
            }
        }
    });
}

// 继续确认函数
function confirmContinue(message, btn, event) {
    return showCustomConfirm(message, event, function (confirmed) {
        if (confirmed && btn && typeof __doPostBack === 'function') {
            // 执行服务器端回发
            __doPostBack(btn.name, '');
        }
    });
}



//DataGrid相关的确认对话框处理函数
// Simple delete confirmation function
function showSimpleDeleteModal(element, event) {
    // Prevent default behavior
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    } else if (window.event) {
        window.event.returnValue = false;
        window.event.cancelBubble = true;
    }

    // Find hidden LinkButton
    var nextSibling = element.nextElementSibling;
    while (nextSibling &&
        (nextSibling.tagName !== 'A' ||
            nextSibling.style.display !== 'none')) {
        nextSibling = nextSibling.nextElementSibling;
    }

    // Alternative search if not found
    if (!nextSibling) {
        var parent = element.parentNode;
        var hiddenButtons = parent.querySelectorAll('a[style*="display:none"], a[style*="display: none"]');
        for (var i = 0; i < hiddenButtons.length; i++) {
            if (hiddenButtons[i].id && hiddenButtons[i].id.indexOf('Delete') !== -1) {
                nextSibling = hiddenButtons[i];
                break;
            }
        }
    }

    if (!nextSibling) {
        console.error('Hidden delete button not found');
        return false;
    }

    var deleteButton = nextSibling;

    // Get CommandArgument
    var deleteID = deleteButton.getAttribute('CommandArgument') ||
        deleteButton.getAttribute('commandargument') || '';

    // Get delete message - check if external function exists
    var message = 'Are you sure you want to delete?';
    if (typeof window.getDeleteMsgByLangCode === 'function') {
        try {
            message = getDeleteMsgByLangCode();
        } catch (e) {
            // Use default if error
        }
    }

    // Get mouse position
    var mouseX = event ? (event.clientX || 0) : 0;
    var mouseY = event ? (event.clientY || 0) : 0;

    // Show modal
    showCustomDeleteModal(message, mouseX, mouseY, function (confirmed) {
        if (confirmed && deleteButton) {
            executeDeleteAction(deleteButton);
        }
    });

    return false;
}

// Show custom delete modal
function showCustomDeleteModal(message, x, y, callback) {
    // Remove existing modals
    var existingOverlay = document.getElementById('customDeleteOverlay');
    var existingModal = document.getElementById('customDeleteModal');
    if (existingOverlay) document.body.removeChild(existingOverlay);
    if (existingModal) document.body.removeChild(existingModal);

    // Get button texts - with fallback
    var buttonTexts = getButtonTextsWithFallback();

    // Create overlay
    var overlay = document.createElement('div');
    overlay.id = 'customDeleteOverlay';
    overlay.style.cssText =
        'position:fixed;' +
        'top:0;' +
        'left:0;' +
        'width:100%;' +
        'height:100%;' +
        'background:rgba(0,0,0,0.5);' +
        'z-index:99999;';

    // Create modal
    var modal = document.createElement('div');
    modal.id = 'customDeleteModal';
    modal.style.cssText =
        'position:fixed;' +
        'background:white;' +
        'padding:20px;' +
        'border-radius:8px;' +
        'box-shadow:0 4px 20px rgba(0,0,0,0.3);' +
        'min-width:300px;' +
        'max-width:400px;' +
        'z-index:100000;' +
        'animation:fadeIn 0.3s;';

    // Add animation style
    if (!document.querySelector('#modalAnimationStyle')) {
        var style = document.createElement('style');
        style.id = 'modalAnimationStyle';
        style.textContent = '@keyframes fadeIn { from { opacity:0; transform:translateY(-20px); } to { opacity:1; transform:translateY(0); } }';
        document.head.appendChild(style);
    }

    // Calculate position
    var top = y - 100;
    var left = x - 150;
    if (top < 20) top = 20;
    if (left < 20) left = 20;
    if (left > window.innerWidth - 320) left = window.innerWidth - 320;

    modal.style.top = top + 'px';
    modal.style.left = left + 'px';

    // Create modal content - Confirm button first, Cancel button second
    modal.innerHTML =
        '<div style="margin-bottom:15px;font-size:16px;color:#333;line-height:1.5;">' +
        message +
        '</div>' +
        '<div style="text-align:right;">' +
        '<button id="modalOkBtn" style="padding:8px 20px;margin-right:10px;background:#dc3545;color:white;border:none;border-radius:4px;cursor:pointer;min-width:80px;font-weight:bold;">' +
        buttonTexts.confirm +
        '</button>' +
        '<button id="modalCancelBtn" style="padding:8px 20px;background:#f0f0f0;color:#333;border:1px solid #ddd;border-radius:4px;cursor:pointer;min-width:80px;">' +
        buttonTexts.cancel +
        '</button>' +
        '</div>';

    // Add to document
    document.body.appendChild(overlay);
    document.body.appendChild(modal);

    // Bind events
    document.getElementById('modalOkBtn').onclick = function () {
        document.body.removeChild(overlay);
        document.body.removeChild(modal);
        callback(true);
    };

    document.getElementById('modalCancelBtn').onclick = function () {
        document.body.removeChild(overlay);
        document.body.removeChild(modal);
        callback(false);
    };

    overlay.onclick = function (e) {
        if (e.target === this) {
            document.body.removeChild(overlay);
            document.body.removeChild(modal);
            callback(false);
        }
    };

    // Keyboard support
    var keyHandler = function (e) {
        if (e.keyCode === 13) { // Enter
            document.body.removeChild(overlay);
            document.body.removeChild(modal);
            document.removeEventListener('keydown', keyHandler);
            callback(true);
        } else if (e.keyCode === 27) { // ESC
            document.body.removeChild(overlay);
            document.body.removeChild(modal);
            document.removeEventListener('keydown', keyHandler);
            callback(false);
        }
    };

    document.addEventListener('keydown', keyHandler);

    // Focus on confirm button
    setTimeout(function () {
        var okBtn = document.getElementById('modalOkBtn');
        if (okBtn) okBtn.focus();
    }, 50);
}

// Get button texts with fallback
function getButtonTextsWithFallback() {
    // Try to get from external function
    if (typeof window.getButtonTextByLang === 'function') {
        try {
            // Get language code
            var langCode = 'en';
            if (typeof getcookie === 'function') {
                langCode = getcookie("LangCode") || 'en';
            } else if (typeof window.getcookie === 'function') {
                langCode = window.getcookie("LangCode") || 'en';
            }

            var texts = getButtonTextByLang(langCode);
            if (texts && texts.confirm && texts.cancel) {
                return texts;
            }
        } catch (e) {
            // Fall back to default
        }
    }

    // Default fallback texts
    return {
        confirm: 'OK',
        cancel: 'Cancel'
    };
}

// Execute delete action
function executeDeleteAction(deleteButton) {
    if (!deleteButton) return;

    if (deleteButton.click) {
        setTimeout(function () {
            deleteButton.click();
        }, 10);
    } else {
        triggerDeleteFallback(deleteButton);
    }
}

// Fallback delete method
function triggerDeleteFallback(deleteButton) {
    if (document.createEvent) {
        var event = document.createEvent('MouseEvents');
        event.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        deleteButton.dispatchEvent(event);
    } else if (deleteButton.fireEvent) {
        deleteButton.fireEvent('onclick');
    } else {
        var uniqueID = deleteButton.name || deleteButton.id;
        if (uniqueID && typeof __doPostBack === 'function') {
            __doPostBack(uniqueID, 'Delete');
        }
    }
}

// Initialize for UpdatePanel
if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        // Reinitialize if needed
    });
}

