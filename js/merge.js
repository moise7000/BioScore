
const mergerState = {
    uploadedFiles: [],
    parsedData: [],
    mergedResults: null,
    statistics: {
    totalBiomarkers: 0,
    highSignificance: 0,
    goodBiomarkers: 0,
    unprovenSignificance: 0,
    notGoodBiomarkers: 0,
    clinicalCases: 0
}
};

    // DOM Elements
    const welcomeScreen = document.getElementById('welcome-screen');
    const mergerInterface = document.getElementById('merger-interface');
    const uploadArea = document.getElementById('upload-area');
    const fileInput = document.getElementById('file-input');
    const fileList = document.getElementById('file-list');
    const statsSection = document.getElementById('stats-section');
    const resultsSection = document.getElementById('results-section');
    const startButton = document.getElementById('start-merger');
    const clearButton = document.getElementById('clear-all');
    const exportButton = document.getElementById('export-merged');

    // Initialize application
    function init() {
    startButton.addEventListener('click', showMergerInterface);
    clearButton.addEventListener('click', clearAll);
    exportButton.addEventListener('click', exportMergedResults);

    // Upload area events
    uploadArea.addEventListener('click', () => fileInput.click());
    uploadArea.addEventListener('dragover', handleDragOver);
    uploadArea.addEventListener('dragleave', handleDragLeave);
    uploadArea.addEventListener('drop', handleDrop);
    fileInput.addEventListener('change', handleFileSelect);
}

    function showMergerInterface() {
    welcomeScreen.style.display = 'none';
    mergerInterface.style.display = 'block';
}

    function handleDragOver(e) {
    e.preventDefault();
    uploadArea.classList.add('dragover');
}

    function handleDragLeave(e) {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
}

    function handleDrop(e) {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    const files = Array.from(e.dataTransfer.files).filter(file => file.type === 'application/json');
    processFiles(files);
}

    function handleFileSelect(e) {
    const files = Array.from(e.target.files);
    processFiles(files);
}

    async function processFiles(files) {
    for (const file of files) {
    if (mergerState.uploadedFiles.some(f => f.name === file.name)) {
    continue; // Skip duplicates
}

    const fileData = {
    name: file.name,
    size: file.size,
    status: 'pending',
    data: null,
    error: null
};

    mergerState.uploadedFiles.push(fileData);
    updateFileList();

    try {
    const content = await readFileContent(file);
    const parsedData = JSON.parse(content);

    // Validate JSON structure
    if (validateBiomarkerJSON(parsedData)) {
    fileData.status = 'success';
    fileData.data = parsedData;
    mergerState.parsedData.push(parsedData);
} else {
    fileData.status = 'error';
    fileData.error = 'Invalid biomarker JSON format';
}
} catch (error) {
    fileData.status = 'error';
    fileData.error = error.message;
}

    updateFileList();
}

    if (mergerState.parsedData.length > 0) {
    processResults();
}
}

    function readFileContent(file) {
    return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = e => resolve(e.target.result);
    reader.onerror = e => reject(new Error('Failed to read file'));
    reader.readAsText(file);
});
}

    function validateBiomarkerJSON(data) {
    return data &&
    data.classification &&
    data.classification.biomarkerName &&
    data.classification.finalResult &&
    data.inputScores;
}

    function updateFileList() {
    fileList.innerHTML = '';

    mergerState.uploadedFiles.forEach((file, index) => {
    const fileItem = document.createElement('div');
    fileItem.className = 'file-item';

    fileItem.innerHTML = `
        <div>
          <span class="file-name">${file.name}</span>
          <span class="file-status ${file.status}">${file.status.toUpperCase()}</span>
          ${file.error ? `<div class="error-message">${file.error}</div>` : ''}
        </div>
        <button class="remove-file" onclick="removeFile(${index})">×</button>
      `;

    fileList.appendChild(fileItem);
});
}

    function removeFile(index) {
    const removedFile = mergerState.uploadedFiles[index];
    mergerState.uploadedFiles.splice(index, 1);

    // Remove from parsed data if it was successfully parsed
    if (removedFile.data) {
    const dataIndex = mergerState.parsedData.findIndex(data =>
    data.classification.biomarkerName === removedFile.data.classification.biomarkerName
    );
    if (dataIndex > -1) {
    mergerState.parsedData.splice(dataIndex, 1);
}
}

    updateFileList();

    if (mergerState.parsedData.length > 0) {
    processResults();
} else {
    hideResults();
}
}

    function processResults() {
    // Calculate statistics
    calculateStatistics();

    // Generate merged results
    generateMergedResults();

    // Update UI
    updateStatisticsDisplay();
    updateResultsDisplay();

    // Show results sections
    statsSection.style.display = 'block';
    resultsSection.style.display = 'block';

    // Enable export button
    exportButton.disabled = false;
}

    function calculateStatistics() {
    const stats = {
    totalBiomarkers: mergerState.parsedData.length,
    highSignificance: 0,
    goodBiomarkers: 0,
    unprovenSignificance: 0,
    notGoodBiomarkers: 0,
    clinicalCases: 0
};

    mergerState.parsedData.forEach(data => {
    const result = data.classification.finalResult.toLowerCase();

    if (result.includes('high scientific significance')) {
    stats.highSignificance++;
    stats.goodBiomarkers++; // High significance is also considered good
} else if (result.includes('not a good biomarker')) {
    stats.notGoodBiomarkers++;
} else if (result.includes('unproven significance')) {
    stats.unprovenSignificance++;
} else if (result.includes('clinical')) {
    stats.clinicalCases++;
}
});

    mergerState.statistics = stats;
}

    function generateMergedResults() {
    const timestamp = new Date().toISOString();

    mergerState.mergedResults = {
    metadata: {
    mergeDate: timestamp,
    applicationVersion: "1.0",
    totalFilesProcessed: mergerState.uploadedFiles.length,
    successfullyParsed: mergerState.parsedData.length,
    failedFiles: mergerState.uploadedFiles.filter(f => f.status === 'error').length
},
    summary: {
    ...mergerState.statistics,
    averageProcessingTime: calculateAverageProcessingTime(),
    uniqueBiomarkers: getUniqueBiomarkers().length
},
    detailedResults: mergerState.parsedData.map(data => ({
    biomarkerName: data.classification.biomarkerName,
    finalResult: data.classification.finalResult,
    inputScores: data.inputScores,
    thresholds: data.thresholds,
    scientificEvidence: data.scientificEvidence,
    processingTime: data.classification.duration,
    exportDate: data.metadata.exportDate
})),
    rawData: mergerState.parsedData
};
}

    function calculateAverageProcessingTime() {
    const validTimes = mergerState.parsedData
    .map(data => data.classification.duration)
    .filter(time => time && !isNaN(time));

    if (validTimes.length === 0) return 0;

    const average = validTimes.reduce((sum, time) => sum + time, 0) / validTimes.length;
    return Math.round(average * 100) / 100;
}

    function getUniqueBiomarkers() {
    const names = mergerState.parsedData.map(data => data.classification.biomarkerName);
    return [...new Set(names)];
}

    function updateStatisticsDisplay() {
    document.getElementById('total-biomarkers').textContent = mergerState.statistics.totalBiomarkers;
    document.getElementById('high-significance').textContent = mergerState.statistics.highSignificance;
    document.getElementById('good-biomarkers').textContent = mergerState.statistics.goodBiomarkers;
    document.getElementById('unproven-significance').textContent = mergerState.statistics.unprovenSignificance;
}

    function updateResultsDisplay() {
    // Update summary
    document.getElementById('files-processed').textContent = mergerState.uploadedFiles.length;
    document.getElementById('total-classifications').textContent = mergerState.parsedData.length;
    document.getElementById('unique-biomarkers').textContent = getUniqueBiomarkers().length;
    document.getElementById('avg-processing-time').textContent = calculateAverageProcessingTime() + 's';

    // Update distribution
    document.getElementById('dist-high-significance').textContent = mergerState.statistics.highSignificance;
    document.getElementById('dist-not-good').textContent = mergerState.statistics.notGoodBiomarkers;
    document.getElementById('dist-unproven').textContent = mergerState.statistics.unprovenSignificance;
    document.getElementById('dist-clinical').textContent = mergerState.statistics.clinicalCases;

    // Update results table
    updateResultsTable();
}

    function updateResultsTable() {
    const tbody = document.getElementById('results-tbody');
    tbody.innerHTML = '';

    mergerState.parsedData.forEach(data => {
    const row = document.createElement('tr');
    const result = data.classification.finalResult;
    const badgeClass = getResultBadgeClass(result);

    row.innerHTML = `
        <td>${data.classification.biomarkerName}</td>
        <td><span class="result-badge ${badgeClass}">${result}</span></td>
        <td>${data.inputScores.consistencyScore?.toFixed(1) || 'N/A'}</td>
        <td>${data.inputScores.reproducibilityScore?.toFixed(1) || 'N/A'}</td>
        <td>${data.inputScores.specificityScore?.toFixed(1) || 'N/A'}</td>
        <td>${(data.scientificEvidence?.totalScientificEvidence || 0)}</td>
        <td>${data.classification.duration ? data.classification.duration.toFixed(1) + 's' : 'N/A'}</td>
      `;

    tbody.appendChild(row);
});
}

    function getResultBadgeClass(result) {
    const lowerResult = result.toLowerCase();
    if (lowerResult.includes('high scientific significance')) return 'result-high-significance';
    if (lowerResult.includes('not a good biomarker')) return 'result-not-good';
    if (lowerResult.includes('unproven significance')) return 'result-unproven';
    if (lowerResult.includes('clinical')) return 'result-clinical';
    return 'result-good';
}

    function exportMergedResults() {
    if (!mergerState.mergedResults) return;

    const timestamp = new Date().toISOString();
    const filename = `merged_biomarker_results_${timestamp.replace(/[:.]/g, '-')}.json`;

    const blob = new Blob([JSON.stringify(mergerState.mergedResults, null, 2)], {
    type: 'application/json'
});

    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

    function clearAll() {
    mergerState.uploadedFiles = [];
    mergerState.parsedData = [];
    mergerState.mergedResults = null;

    updateFileList();
    hideResults();
    exportButton.disabled = true;
}

    function hideResults() {
    statsSection.style.display = 'none';
    resultsSection.style.display = 'none';
}

    // Global function for remove buttons
    window.removeFile = removeFile;

    // Initialize the application
init();
