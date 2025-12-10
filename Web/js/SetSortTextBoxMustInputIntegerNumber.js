// 为所有ID包含"sort"的TextBox控件添加输入限制（不区分大小写）
$(document).ready(function () {
    initializeSortInputValidation();

    // 监听UpdatePanel更新完成事件
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        initializeSortInputValidation();
    });
});

function initializeSortInputValidation() {
    // 遍历所有文本框，找出ID包含"sort"的（不区分大小写）
    $('input[type="text"]').each(function () {
        var textbox = $(this);
        var id = textbox.attr('id') || '';

        // 检查ID是否包含"sort"（不区分大小写）
        if ((!id.toLowerCase().includes('sort')) && (!id.toLowerCase().includes('width'))) {
            return; // 继续下一个元素
        }

        // 跳过已初始化的
        if (textbox.data('sortValidationInitialized')) {
            return;
        }

        textbox.data('sortValidationInitialized', true);

        // 应用验证规则
        applySortValidation(textbox);
    });
}

function applySortValidation(textbox) {
    var originalValue = textbox.val();

    // 添加keydown事件限制输入
    textbox.off('keydown.sortValidation').on('keydown.sortValidation', function (e) {
        var charCode = e.which ? e.which : e.keyCode;

        // 允许控制键：退格、删除、Tab、Enter、方向键
        if ([8, 9, 13, 46, 37, 38, 39, 40].indexOf(charCode) !== -1) {
            return true;
        }

        // 允许数字0-9
        if (charCode >= 48 && charCode <= 57) {
            return true;
        }

        // 禁止其他所有按键
        e.preventDefault();
        return false;
    });

    // 添加blur事件验证最终值
    textbox.off('blur.sortValidation').on('blur.sortValidation', function () {
        var value = textbox.val().trim();

        // 如果为空，设置为0
        if (value === '') {
            textbox.val('0');
            return;
        }

        // 移除前导0（除非是0本身）
        if (value.length > 1 && value.charAt(0) === '0') {
            value = value.replace(/^0+/, '');
            if (value === '') value = '0';
            textbox.val(value);
        }

        // 确保是整数且大于等于0
        var intValue = parseInt(value, 10);
        if (isNaN(intValue)) {
            textbox.val('0');
        } else if (intValue < 0) {
            textbox.val('0');
        } else {
            textbox.val(intValue.toString());
        }
    });

    // 添加paste事件处理
    textbox.off('paste.sortValidation').on('paste.sortValidation', function (e) {
        // 获取粘贴的内容
        var clipboardData = e.originalEvent.clipboardData || window.clipboardData;
        var pastedText = clipboardData.getData('text');

        // 延迟验证粘贴内容
        setTimeout(function () {
            var currentValue = textbox.val();

            // 只保留数字
            var newValue = currentValue.replace(/[^0-9]/g, '');

            // 如果为空，设置为0
            if (newValue === '') {
                textbox.val('0');
                return;
            }

            // 移除前导0（除非是0本身）
            if (newValue.length > 1 && newValue.charAt(0) === '0') {
                newValue = newValue.replace(/^0+/, '');
                if (newValue === '') newValue = '0';
            }

            // 验证范围
            var intValue = parseInt(newValue, 10);
            if (isNaN(intValue)) {
                newValue = '0';
            } else if (intValue < 0) {
                newValue = '0';
            } else {
                newValue = intValue.toString();
            }

            textbox.val(newValue);
        }, 0);
    });

    // 添加input事件实时验证
    textbox.off('input.sortValidation').on('input.sortValidation', function () {
        var value = textbox.val();
        var cursorPosition = textbox[0].selectionStart;

        // 只保留数字
        var newValue = value.replace(/[^0-9]/g, '');

        // 更新值（如果有变化）
        if (value !== newValue) {
            textbox.val(newValue);
            // 恢复光标位置
            var newPosition = Math.max(0, cursorPosition - (value.length - newValue.length));
            textbox[0].setSelectionRange(newPosition, newPosition);
        }
    });

    // 添加focus事件，选中文本方便编辑
    textbox.off('focus.sortValidation').on('focus.sortValidation', function () {
        setTimeout(function () {
            textbox.select();
        }, 100);
    });

    // 初始化验证
    setTimeout(function () {
        if (textbox.val() !== originalValue) {
            textbox.trigger('blur.sortValidation');
        }
    }, 100);
}

// 添加样式突出显示这些文本框 - 修改为左对齐
function styleSortTextboxes() {
    $('input[type="text"]').each(function () {
        var textbox = $(this);
        var id = textbox.attr('id') || '';

        // 检查ID是否包含"sort"（不区分大小写）
        if ((!id.toLowerCase().includes('sort')) && (!id.toLowerCase().includes('width')) ) {
            return;
        }

        // 添加提示样式 - 修改为左对齐
        textbox.css({
            'text-align': 'left', // 改为左对齐
            'font-weight': 'normal',
            'background-color': '#f9f9f9',
            'border': '1px solid #ccc',
            'padding': '4px 8px',
            'direction': 'ltr' // 确保从左到右显示
        });

        // 添加提示文字
        if (!textbox.attr('title')) {
            textbox.attr('title', '请输入大于等于0的整数');
        }

        // 添加占位符提示
        if (!textbox.attr('placeholder')) {
            textbox.attr('placeholder', '0');
        }

        // 添加HTML5验证属性
        textbox.attr('oninvalid', "this.setCustomValidity('请输入大于等于0的整数')");
        textbox.attr('oninput', "this.setCustomValidity('')");
        textbox.attr('pattern', '\\d+');
    });
}

// 页面加载完成后初始化
$(document).ready(function () {
    initializeSortInputValidation();
    styleSortTextboxes();

    // UpdatePanel支持
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        // 清除旧的初始化标记
        $('input[type="text"]').removeData('sortValidationInitialized');

        // 重新初始化
        initializeSortInputValidation();
        styleSortTextboxes();
    });
});

// 扩展功能保持不变
function setAllSortValues(value) {
    var intValue = parseInt(value, 10);
    if (isNaN(intValue) || intValue < 0) {
        intValue = 0;
    }

    $('input[type="text"]').each(function () {
        var textbox = $(this);
        var id = textbox.attr('id') || '';

        if ((id.toLowerCase().includes('sort')) || (id.toLowerCase().includes('width'))) {
            textbox.val(intValue.toString());
            textbox.trigger('blur.sortValidation');
        }
    });
}

function validateAllSortTextboxes() {
    var allValid = true;

    $('input[type="text"]').each(function () {
        var textbox = $(this);
        var id = textbox.attr('id') || '';

        if ((id.toLowerCase().includes('sort')) || (id.toLowerCase().includes('width'))) {
            textbox.trigger('blur.sortValidation');
            var value = textbox.val();
            var intValue = parseInt(value, 10);

            if (isNaN(intValue) || intValue < 0) {
                allValid = false;
                textbox.css('border-color', 'red');
            } else {
                textbox.css('border-color', '#ccc');
            }
        }
    });

    return allValid;
}

function getAllSortValues() {
    var values = {};

    $('input[type="text"]').each(function () {
        var textbox = $(this);
        var id = textbox.attr('id') || '';

        if ((id.toLowerCase().includes('sort')) || (id.toLowerCase().includes('width'))) {
            var value = textbox.val();
            var intValue = parseInt(value, 10);
            values[id] = isNaN(intValue) || intValue < 0 ? 0 : intValue;
        }
    });

    return values;
}