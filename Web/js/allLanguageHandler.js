//多语种退出平台消息
function getExitMsgByLangCode() {

    var varLangCode = getcookie("LangCode");
    var varMsg;

    if (varLangCode == "zh-CN") {
        varMsg = '确定要退出管理平台吗?';
    }
    else if (varLangCode == "zh-tw") {
        varMsg = '確定要退出管理平台嗎?';
    }
    else if (varLangCode == "en") {
        varMsg = 'Are you sure you want to quit the management platform?';
    }
    else if (varLangCode == "de") {
        varMsg = 'Möchten Sie die Verwaltungsplattform wirklich beenden?';
    }
    else if (varLangCode == "es") {
        varMsg = '¿Estás seguro de que quieres abandonar la plataforma de gestión?';
    }
    else if (varLangCode == "fr") {
        varMsg = 'Êtes-vous sûr de vouloir quitter la plate-forme de gestion?';
    }
    else if (varLangCode == "it") {
        varMsg = 'Sei sicuro di voler lasciare la piattaforma di gestione?';
    }
    else if (varLangCode == "ja") {
        varMsg = '管理プラットフォームを終了してもよろしいですか？';
    }
    else if (varLangCode == "ko") {
        varMsg = '관리 플랫폼을 종료 하시겠습니까?';
    }
    else if (varLangCode == "pt") {
        varMsg = 'Tem certeza de que deseja sair da plataforma de gerenciamento?';
    }
    else if (varLangCode == "ru") {
        varMsg = 'Вы действительно хотите выйти из платформы управления?';
    }
    else if (varLangCode == "id") {
        varMsg = 'Apakah Anda yakin ingin keluar dari platform manajemen?';
    }
    else {
        varMsg = 'Are you sure you want to quit the management platform?';
    }

    return varMsg;
}



//多语种项目计划复制消息
function getCopyProjectPlanMsgByLangCode() {

    var varLangCode = getcookie("LangCode");
    var varMsg;

    if (varLangCode == "zh-CN") {
        varMsg = '复制操作会完全覆盖原来的计划数据，您确定要复制吗?';
    }
    else if (varLangCode == "zh-tw") {
        varMsg = '複製操作會完全覆蓋原來的計劃數據，您確定要複製嗎？';
    }
    else if (varLangCode == "en") {
        varMsg = 'Copy operation will delete all old plan data,Are you sure you want to copy it?';
    }
    else if (varLangCode == "de") {
        varMsg = 'Der Kopiervorgang löscht alle alten Plandaten. Sind Sie sicher, dass Sie kopieren möchten?';
    }
    else if (varLangCode == "es") {
        varMsg = 'La operación de copia eliminará todos los datos del plan anterior. ¿Está seguro de que desea copiarlo?';
    }
    else if (varLangCode == "fr") {
        varMsg = 'L\'opération de copie supprimera toutes les anciennes données du plan. Êtes-vous sûr de vouloir le copier?';
    }
    else if (varLangCode == "it") {
        varMsg = 'L\'operazione di copia eliminerà tutti i vecchi dati del piano. Sei sicuro di volerlo copiare?';
    }
    else if (varLangCode == "ja") {
        varMsg = 'コピー操作により古い計画データはすべて削除されます。コピーしてもよろしいですか？';
    }
    else if (varLangCode == "ko") {
        varMsg = '복사 작업은 기존의 모든 계획 데이터를 삭제합니다. 복사하시겠습니까?';
    }
    else if (varLangCode == "pt") {
        varMsg = 'A operação de cópia excluirá todos os dados antigos do plano. Tem certeza de que deseja copiá-lo?';
    }
    else if (varLangCode == "ru") {
        varMsg = 'Операция копирования удалит все старые данные плана. Вы уверены, что хотите скопировать?';
    }
    else if (varLangCode == "id") {
        varMsg = 'Operasi penyalinan akan menghapus semua data rencana lama. Apakah Anda yakin ingin menyalinnya?';
    }
    else {
        varMsg = 'Copy operation will delete all old plan data,Are you sure you want to copy it?';
    }

    return varMsg;
}

//多语种项目计划启动消息
function getStartupProjectPlanMsgByLangCode() {

    var varLangCode = getcookie("LangCode");
    var varMsg;

    if (varLangCode == "zh-CN") {
        varMsg = '启动后，计划内容不能更改，确定要启动吗?';
    }
    else if (varLangCode == "zh-tw") {
        varMsg = '啟動後，計劃內容不能更改，確定要啟動嗎？';
    }
    else if (varLangCode == "en") {
        varMsg = 'After launching, the content of the plan cannot be changed, are you sure you want to start?';
    }
    else if (varLangCode == "de") {
        varMsg = 'Nach dem Start können die Planinhalte nicht mehr geändert werden. Sind Sie sicher, dass Sie starten möchten?';
    }
    else if (varLangCode == "es") {
        varMsg = 'Después del lanzamiento, el contenido del plan no se puede cambiar. ¿Está seguro de que desea iniciar?';
    }
    else if (varLangCode == "fr") {
        varMsg = 'Après le lancement, le contenu du plan ne peut pas être modifié. Êtes-vous sûr de vouloir commencer?';
    }
    else if (varLangCode == "it") {
        varMsg = 'Dopo il lancio, il contenuto del piano non può essere modificato. Sei sicuro di voler iniziare?';
    }
    else if (varLangCode == "ja") {
        varMsg = '起動後、計画の内容は変更できません。起動してもよろしいですか？';
    }
    else if (varLangCode == "ko") {
        varMsg = '시작 후에는 계획 내용을 변경할 수 없습니다. 시작하시겠습니까?';
    }
    else if (varLangCode == "pt") {
        varMsg = 'Após o lançamento, o conteúdo do plano não pode ser alterado. Tem certeza de que deseja iniciar?';
    }
    else if (varLangCode == "ru") {
        varMsg = 'После запуска содержание плана нельзя изменить. Вы уверены, что хотите начать?';
    }
    else if (varLangCode == "id") {
        varMsg = 'Setelah diluncurkan, konten rencana tidak dapat diubah. Apakah Anda yakin ingin memulai?';
    }
    else {
        varMsg = 'After launching, the content of the plan cannot be changed, are you sure you want to start?';
    }

    return varMsg;
}

//多语种项目计划拼接消息
function getJoinProjectPlanMsgByLangCode() {

    var varLangCode = getcookie("LangCode");
    var varMsg;

    if (varLangCode == "zh-CN") {
        varMsg = '拼接操作会影响原来的计划结构，您确定要拼接吗?';
    }
    else if (varLangCode == "zh-tw") {
        varMsg = '拼接操作會影響原來的計劃結構，您確定要拼接嗎';
    }
    else if (varLangCode == "en") {
        varMsg = 'Joint operation will impact old plan data,Are you sure you want to joint it?';
    }
    else if (varLangCode == "de") {
        varMsg = 'Die Verbundoperation wirkt sich auf alte Plandaten aus. Sind Sie sicher, dass Sie verbinden möchten?';
    }
    else if (varLangCode == "es") {
        varMsg = 'La operación de unión afectará los datos del plan anterior. ¿Está seguro de que desea unirlo?';
    }
    else if (varLangCode == "fr") {
        varMsg = 'L\'opération de jointure affectera les anciennes données du plan. Êtes-vous sûr de vouloir le joindre?';
    }
    else if (varLangCode == "it") {
        varMsg = 'L\'operazione di giunzione influenzerà i vecchi dati del piano. Sei sicuro di volerlo unire?';
    }
    else if (varLangCode == "ja") {
        varMsg = '結合操作は元の計画構造に影響します。結合してもよろしいですか？';
    }
    else if (varLangCode == "ko") {
        varMsg = '결합 작업은 기존 계획 구조에 영향을 미칩니다. 결합하시겠습니까?';
    }
    else if (varLangCode == "pt") {
        varMsg = 'A operação de junção afetará a estrutura do plano antigo. Tem certeza de que deseja juntá-lo?';
    }
    else if (varLangCode == "ru") {
        varMsg = 'Операция соединения повлияет на старую структуру плана. Вы уверены, что хотите соединить?';
    }
    else if (varLangCode == "id") {
        varMsg = 'Operasi penggabungan akan mempengaruhi struktur rencana lama. Apakah Anda yakin ingin menggabungkannya?';
    }
    else {
        varMsg = 'Joint operation will impact old plan data,Are you sure you want to joint it?';
    }

    return varMsg;
}

//多语种删除消息
function getDeleteMsgByLangCode() {

    var varLangCode = getcookie("LangCode");
    var varMsg;

    if (varLangCode == "zh-CN") {
        varMsg = '确定要删除吗?';
    }
    else if (varLangCode == "zh-tw") {
        varMsg = '確定要刪除嗎？';
    }
    else if (varLangCode == "en") {
        varMsg = 'Are you sure you want to delete?';
    }
    else if (varLangCode == "de") {
        varMsg = 'Sind Sie sicher, dass Sie löschen möchten?';
    }
    else if (varLangCode == "es") {
        varMsg = '¿Estás seguro de que quieres eliminarlo?';
    }
    else if (varLangCode == "fr") {
        varMsg = 'Êtes-vous sûr de vouloir supprimer ?';
    }
    else if (varLangCode == "it") {
        varMsg = 'Sei sicuro di voler eliminare?';
    }
    else if (varLangCode == "ja") {
        varMsg = '削除してもよろしいですか?';
    }
    else if (varLangCode == "ko") {
        varMsg = '삭제하시겠습니까?';
    }
    else if (varLangCode == "pt") {
        varMsg = 'Tem certeza de que deseja excluir?';
    }
    else if (varLangCode == "ru") {
        varMsg = 'Вы уверены, что хотите удалить?';
    }
    else if (varLangCode == "id") {
        varMsg = 'Apakah Anda yakin ingin menghapus?';
    }
    else {
        varMsg = 'Are you sure you want to delete?';
    }

    return varMsg;
}

// 根据语言代码获取按钮文本
function getButtonTextByLang(langCode) {
    var texts = {
        confirm: '确定',
        cancel: '取消'
    };

    switch (langCode) {
        case 'zh-CN':
            texts.confirm = '确定';
            texts.cancel = '取消';
            break;
        case 'zh-tw':
            texts.confirm = '確定';
            texts.cancel = '取消';
            break;
        case 'en':
            texts.confirm = 'OK';
            texts.cancel = 'Cancel';
            break;
        case 'de':
            texts.confirm = 'Bestätigen';
            texts.cancel = 'Abbrechen';
            break;
        case 'es':
            texts.confirm = 'Aceptar';
            texts.cancel = 'Cancelar';
            break;
        case 'fr':
            texts.confirm = 'Confirmer';
            texts.cancel = 'Annuler';
            break;
        case 'it':
            texts.confirm = 'Conferma';
            texts.cancel = 'Annulla';
            break;
        case 'ja':
            texts.confirm = '確認';
            texts.cancel = 'キャンセル';
            break;
        case 'ko':
            texts.confirm = '확인';
            texts.cancel = '취소';
            break;
        case 'pt':
            texts.confirm = 'Confirmar';
            texts.cancel = 'Cancelar';
            break;
        case 'id':
            texts.confirm = 'Konfirmasi';
            texts.cancel = 'Batal';
            break;
        case 'ru':
            texts.confirm = 'Подтвердить';
            texts.cancel = 'Отмена';
            break;
        default:
            texts.confirm = 'OK';
            texts.cancel = 'Cancel';
    }

    return texts;
}
