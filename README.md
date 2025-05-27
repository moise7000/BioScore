# Politecnico di Milano - BioScore - 2025

A comprehensive web-based application for evaluating and classifying biomarkers based on their consistency, reproducibility, specificity, and scientific significance. The system provides both individual biomarker classification and batch result merging capabilities.

## Features

### 🔬 Biomarker Classification
- **Interactive Decision Flow**: Guided step-by-step evaluation process
- **Configurable Thresholds**: Adjustable parameters for consistency, reproducibility, and specificity
- **Scientific Evidence Evaluation**: Assessment of peer-reviewed publications and official statements
- **Health Outcomes Analysis**: Evaluation of general health improvement, chronic disease risk reduction, and disease management support
- **Real-time Status Tracking**: Live updates of classification progress and current values
- **JSON Export**: Save detailed classification results with complete audit trail

### 📊 Results Merger
- **Batch Processing**: Upload and merge multiple JSON classification files
- **Statistical Analysis**: Comprehensive statistics and distribution analysis
- **Data Validation**: Automatic validation of uploaded JSON files
- **Interactive Results Table**: Detailed view of all processed biomarkers
- **Export Capabilities**: Generate merged reports in JSON format

## Getting Started

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, Edge)
- No server installation required - runs entirely in the browser

### Installation
1. Clone or download the project files
2. Open `index.html` in your web browser
3. Choose your desired tool:
    - **Biomarker Classification**: For individual biomarker evaluation
    - **Results Merger**: For combining multiple classification results

## Usage

### Individual Biomarker Classification

1. **Start Classification**: Click "Start Classification" from the main menu
2. **Configure Settings** (Optional): Click the settings icon to adjust:
    - Consistency threshold (tc)
    - Reproducibility threshold (tr)
    - Specificity threshold (ts)
    - Health improvement thresholds (t1, t2, t3)
    - Backend enabler toggle

3. **Follow the Guided Process**:
    - Enter biomarker name
    - Input consistency, reproducibility, and specificity values
    - Answer classification questions (General wellness vs Clinical)
    - Provide health outcome assessments
    - Enter scientific evidence details

4. **Review Results**: The system will classify your biomarker into one of several categories:
    - High scientific significance
    - Unproven significance
    - Not a good biomarker
    - Clinical use case (out of scope)

5. **Save Results**: Export detailed JSON file with complete classification data

### Results Merger

1. **Start Merger**: Click "Start Merging" from the main menu
2. **Upload Files**:
    - Drag and drop JSON files from previous classifications
    - Or click to browse and select files
    - Files are automatically validated

3. **Review Statistics**:
    - Total biomarkers processed
    - Distribution of classification results
    - Processing time analysis
    - Unique biomarker count

4. **Export Merged Results**: Generate comprehensive report combining all uploaded classifications

## Classification Algorithm

The system uses a multi-step decision tree algorithm:

1. **Initial Validation**: Checks if biomarker meets minimum thresholds for consistency, reproducibility, and specificity
2. **Use Case Classification**: Distinguishes between general wellness and clinical applications
3. **Health Outcomes Assessment**: Evaluates potential health benefits across three categories
4. **Scientific Evidence Review**: Analyzes peer-reviewed publications and official statements
5. **Final Classification**: Assigns final significance rating based on accumulated evidence

### Threshold Parameters

- **tc, tr, ts**: Minimum required values for consistency, reproducibility, and specificity
- **t1, t2, t3**: Thresholds for health improvement categories
- **Backend Enabler**: Toggle for alternative evaluation paths

## File Structure

```
biomarker-system/
├── index.html              # Main landing page
├── serialisation.html      # Classification interface
├── merging.html           # Results merger interface
├── css/
│   └── styles.css         # Application styles
└── js/
    ├── serialization.js   # Classification logic
    └── merge.js          # Merger functionality
```

## Data Export Format

### Individual Classification Export
```json
{
  "metadata": {
    "exportDate": "ISO timestamp",
    "applicationVersion": "1.0",
    "biomarkerName": "string"
  },
  "classification": {
    "biomarkerName": "string",
    "finalResult": "string",
    "startTime": "ISO timestamp",
    "endTime": "ISO timestamp",
    "duration": "number (seconds)"
  },
  "inputScores": {
    "consistencyScore": "number",
    "reproducibilityScore": "number",
    "specificityScore": "number"
  },
  "scientificEvidence": {
    "validPublicationCount": "number",
    "validStatementCount": "number",
    "totalScientificEvidence": "number"
  },
  "classificationHistory": {
    "responses": [...],
    "pathTaken": [...],
    "stepsCompleted": "number"
  }
}
```

### Merged Results Export
```json
{
  "metadata": {
    "mergeDate": "ISO timestamp",
    "totalFilesProcessed": "number",
    "successfullyParsed": "number"
  },
  "summary": {
    "totalBiomarkers": "number",
    "highSignificance": "number",
    "goodBiomarkers": "number",
    "averageProcessingTime": "number"
  },
  "detailedResults": [...],
  "rawData": [...]
}
```

## Browser Compatibility

- ✅ Chrome 70+
- ✅ Firefox 65+
- ✅ Safari 12+
- ✅ Edge 79+

## Technical Notes

- **Client-Side Processing**: All processing occurs in the browser - no server required
- **Data Privacy**: No data is transmitted to external servers
- **File Validation**: Automatic validation of JSON structure and required fields
- **Error Handling**: Comprehensive error handling for file uploads and processing
- **Responsive Design**: Works on desktop and tablet devices

## Troubleshooting

### Common Issues

**Files won't upload in merger**
- Ensure files are valid JSON format
- Check that files contain required biomarker classification structure
- File names should not contain special characters

**Classification gets stuck**
- Check browser console for JavaScript errors
- Try refreshing the page and restarting
- Ensure all required fields are filled

**Export not working**
- Check browser download permissions
- Ensure popup blocker is not interfering
- Try using a different browser


